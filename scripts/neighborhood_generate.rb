require 'smarter_csv'

def create_neighborhood
  rows = SmarterCSV.process('scripts/bairros_com_id.csv')

  rows.each do |row|
    name = row[:bairro]
    idx = row[:id]
    
    neighborhood = Neighborhood.create(
      name: name,
      index: idx
    )

  end
end