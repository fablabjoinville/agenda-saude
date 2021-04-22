module Operator
  module PatientsHelper
    LINKS = %i[all locked].freeze

    def patients_nav_links(current_filter, current_search, total_count)
      links = LINKS.map do |key|
        filter = Operator::PatientsController::FILTERS[key]
        active = filter == current_filter
        text = t("patients.state.#{key}")
        text << " (#{total_count})" if active

        tag.li(class: 'nav-item') do
          link_to text,
                  operator_patients_path(filter: filter),
                  data: { cy: "#{filter}ListTab" },
                  class: "nav-link #{active && :active}"
        end
      end
      links << search_link(current_search, total_count, operator_patients_path(search: current_search)) if current_search.present?
      links.join.html_safe # rubocop:disable Rails/OutputSafety
    end
  end
end
