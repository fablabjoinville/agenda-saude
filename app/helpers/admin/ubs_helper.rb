module Admin
  module UbsHelper
    def human_shifts(ubs, weekday: 1)
      windows = ubs.time_windows(weekday)
      return 'fechado' if windows.empty?

      windows.map { |t| t.map { |h| h.strftime('%H:%M') }.join('-') }.join(', ')
    end
  end
end
