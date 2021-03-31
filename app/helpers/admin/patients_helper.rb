module Admin
  module PatientsHelper
    LINKS = %i[all locked].freeze

    def admin_nav_links(current_filter, current_search, total_count)
      filter_tabs_links(
        current_filter: current_filter,
        total_count: total_count,
        links: LINKS,
        filters: Admin::PatientsController::FILTERS,
        i18n_scope: :patients,
        path: ->(args) { admin_patients_path(**args) }
      ).tap do |links|
        links << search_link(current_search, total_count, admin_patients_path(search: current_search)) if current_search.present?
      end.join.html_safe # rubocop:disable Rails/OutputSafety
    end
  end
end
