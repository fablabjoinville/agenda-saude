module Operator
  module AppointmentsHelper
    LINKS = %i[all waiting checked_in checked_out].freeze

    def operator_nav_links(current_filter, current_search, total_count)
      filter_tabs_links(current_filter, total_count).tap do |links|
        links << search_link(current_search, total_count) if current_search.present?
      end.join.html_safe # rubocop:disable Rails/OutputSafety
    end

    def filter_tabs_links(current_filter, total_count)
      LINKS.map do |key|
        filter = Operator::AppointmentsController::FILTERS[key]
        active = filter == current_filter
        text = t("appointments.state.#{key}")
        text << " (#{total_count})" if active

        tag.li(class: 'nav-item') do
          link_to text, operator_appointments_path(filter: filter), data: { cy: "#{filter}ListTab" },
                                                                    class: "nav-link #{active && :active}"
        end
      end
    end

    def search_link(current_search, total_count)
      tag.li(class: 'nav-item') do
        link_to "Busca: #{current_search} (#{total_count})",
                operator_appointments_path(search: current_search),
                class: 'nav-link active',
                data: 'searchListTab'
      end
    end
  end
end
