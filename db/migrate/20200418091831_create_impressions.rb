class CreateImpressions < ActiveRecord::Migration[5.2]
  def change
    create_table :impressions do |t|
      t.references :user, foreign_key: true
      t.references :blog, foreign_key: true
      t.string :user_agent

      t.timestamps
    end
  end
end
