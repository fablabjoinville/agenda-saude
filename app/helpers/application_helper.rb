module ApplicationHelper
  def self.humanize_datetime(date)
    date.strftime('%d/%m/%Y às %H:%M')
  end

  def self.humanize_date(date)
    date.strftime('%d/%m/%Y')
  end

  def self.humanize_time(date)
    date.strftime('%H:%M')
  end

  def self.humanize_cpf(cpf)
    "#{cpf[0..2]}.#{cpf[3..5]}.#{cpf[6..8]}-#{cpf[9..11]}"
  end

  def search_link(current_search, total_count, path)
    tag.li(class: 'nav-item') do
      link_to "Busca: #{current_search} (#{total_count})",
              path,
              class: 'nav-link active',
              data: 'searchListTab'
    end
  end
end
