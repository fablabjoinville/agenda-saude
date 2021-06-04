class CreatePatientsInquiryAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :patients_inquiry_answers do |t|
      t.references :patient, null: false, index: true
      t.references :inquiry_answer, null: false, index: true

      t.timestamps
    end
  end
end
