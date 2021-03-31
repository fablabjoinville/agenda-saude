module Admin
  module PatientsHelper
    LINKS = %i[all locked].freeze

    def admin_nav_links(current_filter, current_search, total_count)
      admin_filter_tabs_links(current_filter, total_count).tap do |links|
        links << search_link(current_search, total_count) if current_search.present?
      end.join.html_safe # rubocop:disable Rails/OutputSafety
    end

    def admin_filter_tabs_links(current_filter, total_count)
      LINKS.map do |key|
        filter = Admin::PatientsController::FILTERS[key]
        active = filter == current_filter
        text = t("patients.state.#{key}")
        text << " (#{total_count})" if active

        tag.li(class: 'nav-item') do
          link_to text, admin_patients_path(filter: filter), data: { cy: "#{filter}ListTab" },
                                                             class: "nav-link #{active && :active}"
        end
      end
    end

    def admin_search_link(current_search, total_count)
      tag.li(class: 'nav-item') do
        link_to "Busca: #{current_search} (#{total_count})",
                admin_patients_path(search: current_search),
                class: 'nav-link active',
                data: 'searchListTab'
      end
    end
  end
end
