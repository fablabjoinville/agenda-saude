class CreateInquiryAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :inquiry_answers do |t|
      t.string :text, null: false
      t.references :inquiry_question, null: false, index: true
      t.integer :position, default: 0, null: false, index: true
      t.boolean :active, default: true, null: false, index: true

      t.timestamps
    end
  end
end
