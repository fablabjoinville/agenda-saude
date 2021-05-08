module ApplicationHelper
  def self.humanize_cpf(cpf)
    "#{cpf[0..2]}.#{cpf[3..5]}.#{cpf[6..8]}-#{cpf[9..11]}"
  end

  def humanize_phone_number(phone)
    phone.to_s.gsub(/(\d{2})(\d{4,5})(\d{4})/, '(\1) \2-\3')
  end

  def search_link(current_search, total_count, path)
    tag.li(class: 'nav-item') do
      link_to "Busca: #{current_search} (#{total_count})",
              path,
              class: 'nav-link active',
              data: 'searchListTab'
    end
  end

  def error_messages_for(object)
    return nil if object.errors.empty?

    tag.div(class: 'alert alert-danger') do
      tag.h4 do
        quantity = object.errors.count > 1 ? 'other' : 'one'
        t "errors.template.header.#{quantity}", model: object.model_name.human.downcase, count: object.errors.count
      end +
        error_messages_list(object.errors.full_messages)
    end
  end

  # rubocop:disable Metrics/ParameterLists
  def filter_tabs_links(current_filter:, total_count:, links:, filters:, i18n_scope:, path:)
    links.map do |key|
      filter = filters[key]
      active = filter == current_filter
      text = t("#{i18n_scope}.state.#{key}")
      text << " (#{total_count})" if active

      tag.li(class: 'nav-item') do
        link_to text, path.call(filter: filter), data: { cy: "#{filter}ListTab" },
                                                 class: "nav-link #{active && :active}"
      end
    end
  end

  # rubocop:enable Metrics/ParameterLists

  protected

  def error_messages_list(full_messages)
    tag.ul { safe_join(full_messages.map { |msg| tag.li(msg) }) }
  end
end
