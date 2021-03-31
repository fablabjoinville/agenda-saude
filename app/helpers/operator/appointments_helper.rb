module Operator
  module AppointmentsHelper
    LINKS = %i[all waiting checked_in checked_out].freeze

    def operator_nav_links(current_filter, current_search, total_count)
      filter_tabs_links(
        current_filter: current_filter,
        total_count: total_count,
        links: LINKS,
        filters: Operator::AppointmentsController::FILTERS,
        i18n_scope: :appointments,
        path: ->(args) { operator_appointments_path(**args) }
      ).tap do |links|
        if current_search.present?
          links << search_link(current_search, total_count,
                               operator_appointments_path(search: current_search))
        end
      end.join.html_safe # rubocop:disable Rails/OutputSafety
    end
  end
end
