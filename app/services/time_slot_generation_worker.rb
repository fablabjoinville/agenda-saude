class TimeSlotGenerationWorker
  class Options < OpenStruct
    DEFAULTS = {
      sleep_interval: 60.seconds,
      execution_hour: 22
    }.freeze

    def initialize(options = {})
      symbolized_options = options.symbolize_keys

      raise 'Time slot generation worker options must be a hash' \
        unless options.is_a?(Hash)

      unrecognized_options = symbolized_options.keys - DEFAULTS.keys

      raise "Unrecognized options: #{unrecognized_options.inspect}" \
        if unrecognized_options.any?

      normalized_options = DEFAULTS.map do |key, value|
        [key, symbolized_options[key] || value]
      end.to_h

      super(normalized_options)
    end
  end

  def initialize(time_slot_generation_service:)
    @time_slot_generation_service = time_slot_generation_service
  end

  def execute(options: TimeSlotGenerationWorker::Options.new)
    loop do
      sleep(options.sleep_interval.to_i)

      current_time = Time.now.in_time_zone

      next unless current_time.hour == options.execution_hour

      # If we ever scale to multiple nodes, this ensures only one job will run
      result = ActiveRecord::Base.connection.execute(
        "INSERT INTO time_slot_generator_executions (date, status) " \
          "VALUES ('#{current_time.to_date.to_s(:db)}', 'running') " \
          "ON CONFLICT DO NOTHING RETURNING true AS inserted"
      )

      # Record already exists
      # (SQL 'RETURNING' does not return anything on conflict)
      if result.none?
        Rails.logger.debug('Already executed today. Skipping')
        # Sleep longer to avoid hitting the db every sleep interval,
        # as current_time.hour == execution_hour will be true consecutively
        sleep(30.minutes.to_i)
        next
      end

      # This particular notification should be synchronous because
      # we must always know when an execution happens. If success
      # or failure notifications do not arrive it's fine because
      # we know some issue happened inbetween.
      SlackNotifier.info('Iniciando geração de time slots', async: false)

      begin
        Ubs.active.each do |ubs|
          generate_ubs_time_slots(ubs, options, current_time)
        end

        TimeSlotGeneratorExecution
          .where(date: current_time.to_date)
          .update_all(status: 'done')

        SlackNotifier.success('Geração de time slots finalizada com sucesso')
      rescue StandardError => e
        error = "#{e.class.name}: #{e.message}"
        Rails.logger.warn(error)

        TimeSlotGeneratorExecution
          .where(date: current_time.to_date)
          .update_all(status: 'failed', details: error)

        SlackNotifier.error(
          "Geração de time slots falhou (#{error}). Mais detalhes no Sentry."
        )

        Sentry.capture_exception(e)
      end
    end
  end

  def generate_ubs_time_slots(ubs, options, current_time)
    config = ubs.time_slot_generation_config

    return if config.blank?

    max_appointment_time_ahead = config[:max_appointment_time_ahead].seconds

    first_dose_date = ENV['RAILS_ENV'] == 'production' ? current_time + max_appointment_time_ahead + 1.day : current_time + max_appointment_time_ahead

    generation_options = TimeSlotGenerationService::Options.new(
      start_date: first_dose_date.to_datetime,
      end_date: first_dose_date.to_datetime,
      ubs_id: ubs.id,
      windows: config[:windows],
      slot_interval_minutes: ubs.slot_interval_minutes,
      group: config[:group],
      min_age: config[:min_age],
      commorbidity: config[:commorbidity],
      # These don't exist or are incomplete on
      # UBS record, so they must be changed here
      weekdays: [*0..6],
      excluded_dates: []
    )

    @time_slot_generation_service.execute(generation_options)
  end
end
