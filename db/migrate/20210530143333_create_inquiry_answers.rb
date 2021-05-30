class CreateInquiryAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :inquiry_answers do |t|
      t.string :text, null: false
      t.references :inquiry_question, null: false
      t.integer :position, default: 0, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
