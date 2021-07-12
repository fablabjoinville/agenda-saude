module Operator
  class AppointmentsController < Base
    before_action :set_ubs

    FILTERS = {
      search: 'search',
      all: 'all',
      waiting: 'waiting',
      checked_in: 'checked_in',
      checked_out: 'checked_out'
    }.freeze

    # rubocop:disable Metrics/AbcSize
    def index
      appointments = @ubs.appointments
                         .today
                         .scheduled
                         .includes(:patient)

      @appointments = filter(search(appointments))
                      .order(:start)
                      .joins(:patient)
                      .order(Patient.arel_table[:name].lower.asc)
                      .page(index_params[:page])
                      .per([[25, index_params[:per_page].to_i].max, 10_000].min) # max of 10k is for exporting to XLS

      respond_to do |format|
        format.html
        format.xlsx do
          response.headers['Content-Disposition'] = "attachment; filename=\"vacina_agendamentos_#{Date.current}.xlsx\""
        end
      end
    end
    # rubocop:enable Metrics/AbcSize

    private

    # Filters out appointments
    def filter(appointments)
      # use @filter from search, or input from param (permit-listed), or set to default "waiting"
      @filter ||= (FILTERS.values & [index_params[:filter].to_s]).presence&.first || FILTERS[:waiting]

      case @filter
      when FILTERS[:waiting]
        appointments.not_checked_in.not_checked_out
      when FILTERS[:checked_in]
        appointments.checked_in.not_checked_out
      when FILTERS[:checked_out]
        appointments.checked_in.checked_out
      else
        appointments
      end
    end

    # Searches for specific appointments
    def search(appointments)
      if index_params[:search].present? && index_params[:search].size >= 3
        @filter = FILTERS[:search] # In case we're searching, use special filter
        @search = index_params[:search]
        return appointments.search_for(@search)
      end

      appointments
    end

    def index_params
      params.permit(:per_page, :page, :search, :filter)
    end

    def set_ubs
      @ubs = current_user.ubs.find(params[:ubs_id])
    end
  end
end
