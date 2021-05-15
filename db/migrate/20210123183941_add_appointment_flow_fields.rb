class AddAppointmentFlowFields < ActiveRecord::Migration[6.0]
  # rubocop:disable Rails/BulkChangeTable
  def change
    add_column :appointments, :check_in, :datetime
    add_column :appointments, :check_out, :datetime
    add_column :appointments, :second_dose, :boolean, default: false
  end
  # rubocop:enable Rails/BulkChangeTable
end
