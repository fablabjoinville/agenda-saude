module Operator
  module AppointmentsHelper
    LINKS = %i[all waiting checked_in checked_out].freeze

    def operator_nav_links(ubs, current_filter, current_search, total_count)
      links = LINKS.map do |key|
        filter = Operator::AppointmentsController::FILTERS[key]
        active = filter == current_filter
        text = t("appointments.state.#{key}")
        text << " (#{total_count})" if active

        tag.li(class: 'nav-item') do
          link_to text,
                  operator_ubs_appointments_path(ubs, filter: filter),
                  data: { cy: "#{filter}ListTab" },
                  class: "nav-link #{active && :active}"
        end
      end

      if current_search.present?
        links << search_link(current_search, total_count,
                             operator_ubs_appointments_path(ubs, search: current_search))
      end

      links.join.html_safe # rubocop:disable Rails/OutputSafety
    end
  end
end
