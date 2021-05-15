module KaminariHelper
  def link_to_entries_previous_page(entries)
    link_to_previous_page entries, '< Página anterior', class: 'pagination-link', data: { cy: 'previousPageLink' }
  end

  def link_to_entries_next_page(entries)
    link_to_next_page entries, 'Próxima página >', class: 'pagination-link', data: { cy: 'nextPageLink' }
  end
end
