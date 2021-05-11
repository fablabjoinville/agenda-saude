# rubocop:disable Layout/LineLength
[
  {
    path: 'home',
    title: 'Página inicial',
    body: "## Dúvidas frequentes sobre a vacinação\r\n\r\n### Quem não pode tomar a vacina\r\n\r\n* Menores de 18 anos;\r\n* Pessoas com estado febril;\r\n* Pessoas que tiveram suspeita ou Covid-19 positivo nos últimos 30 dias;\r\n* Quem tomou qualquer outra vacina nos últimos 14 dias.\r\n\r\n### Quais documentos preciso levar?\r\n\r\n* Documento oficial de identificação com foto.\r\n* Se imunossuprimido, obrigatório apresentar liberação médica por escrito autorizando a aplicação da vacina.\r\n* Carteira de vacinação, caso possua.\r\n* Crachá funcional, holerite/folha de pagamento, carteira de trabalho ou declaração que comprove vínculo ativo com serviço de saúde no Município de Joinville (em caso de terceirizados e estagiários, a declaração deve ser emitida pelo serviço de saúde contratante, para comprovar o vínculo). Para autônomos, é necessário apresentar comprovante como cadastro de autônomo, RPA, ISS ou MEI\r\n* Se trabalhador atuante em serviços de saúde no Município de Joinville com comorbidades estabelecidas pelo Programa Nacional de Imunização (PNI), apresentar atestado, declaração, laudo ou receita médica que comprove a condição clínica. Trazer ainda autorização médica para receber a vacina.\r\n* Considerando o [Item 4 do Ofício OFÍCIO Nº 234/2021/CGPNI/DEIDT/SVS/MS de 11 de março de 2021](https://bit.ly/3tZSpE7), os estabelecimentos de Interesse à Saúde (exemplos: academias de ginástica, clubes, salão de beleza, clínica de estética, óticas, estúdios de tatuagem e estabelecimentos de saúde animal) NÃO serão contemplados nos grupos prioritários elencados inicialmente para a vacinação.\r\n\r\n[Dúvidas sobre a vacinação e mais informações sobre o combate ao coronavírus](https://www.joinville.sc.gov.br/vacina-do-coronavirus-em-joinville-perguntas-e-respostas/)\r\n\r\nProblemas de acesso ao site? [Clique aqui](https://api.whatsapp.com/send?phone=554734815165). Atendimento de Segunda a sexta-feira - 07:00–20:00, exceto feriados e pontos facultativos.\r\n\r\n## Manifestar-se\r\n\r\nRegistrar [manifestação](https://www.joinville.sc.gov.br/servicos/registrar-manifestacao-a-ouvidoria/) para reclamação, sugestão ou elogio sobre estas informações. Para informações adicionais, [registrar pedido de informação](https://www.joinville.sc.gov.br/servicos/registrar-pedido-de-informacao/).\r\n",
    context: 'embedded'
  }
].each do |h|
  Page.find_or_initialize_by(path: h[:path]).tap do |page|
    page.attributes = h
    page.save!
  end
end
# rubocop:enable Layout/LineLength
