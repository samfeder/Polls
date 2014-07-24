class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :respondent_id
      t.integer :answer_id

      t.timestamps
    end

    add_index :responses, :respondent_id
    add_index :responses, :answer_id
  end
end
