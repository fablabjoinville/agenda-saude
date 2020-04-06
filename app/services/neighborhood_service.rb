module NeighborhoodService
  def self.list
    [
      "Adhemar Garcia", "América", "Anita Garibaldi", "Atiradores", "Aventureiro", "Boa Vista", "Boehmerwald", "Bom Retiro",
      "Bucarein", "Centro", "Comasa", "Costa e Silva", "Espinheiros", "Fátima", "Floresta", "Glória", "Guanabara",
      "Itaum", "Itinga", "Parque Guarani", "Jardim Iririú", "Jardim Paraíso", "Jardim Sophia", "Jarivatuba", "Jativoca",
      "João Costa", "Morro do Meio", "Nova Brasília", "Paranaguamirim", "Petrópolis", "Pirabeiraba", "Profipo", "Saguaçu",
      "Santa Catarina", "Santo Antônio", "São Marcos", "Ulysses Guimarães", "Vila Cubatão", "Vila Nova", "Zona Industrial Norte", "Zona Industrial Tupy"
    ].sort.uniq
  end
end
