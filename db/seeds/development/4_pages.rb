[
  {
    path: 'home',
    title: 'Página inicial',
    body: 'x',
    context: 'embedded'
  }
].each do |h|
  Page.find_or_initialize_by(path: h[:path]).tap do |page|
    page.attributes = h
    page.save!
  end
end
