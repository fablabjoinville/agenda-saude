class CreateInquiryQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :inquiry_questions do |t|
      t.string :text, null: false
      t.integer :form_type, default: 0, null: false
      t.integer :position, default: 0, null: false, index: true
      t.boolean :active, default: true, null: false, index: true

      t.timestamps
    end
  end
end
