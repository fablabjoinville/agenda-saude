module MotherNameService
  MOTHER_LIST = %w[
    Eliza Alice Laura Rosa Adelaide Clarissa Helena Ariela Augustine Bella Betina Celina Charlotte Cloe Elen Felipa
    Jade Julieta Juliete Kira Laisla Leona Lia Lis Louise Maia Martina Megan Mia Micaela Naomi Penélope Pilar Serena Tâmara
    Tarsila Zoe Yeda Adeline Adelaide Patricia Brenda Debra Michelle Sarah Jennifer Adalasia Santina Giuliana Corina
    Marsilia Aurora Cecília Rosanna Leandra Graziella Giulieta Paola Olga Rafaela Eva Silvia Berenice Allegra Lívia
    Fiametta Dulce Iuliana Galicia Micola Cathalina Anzola Fordelise Giorgia Fabia Filippa Melissa Vanessa Verônica
    Adele Iris Antonella
  ].freeze

  def self.name_list(name)
    (MOTHER_LIST.reject { |mother| mother == name }.sample(8) << name).sort
  end
end
