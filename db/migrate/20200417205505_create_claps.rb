class CreateClaps < ActiveRecord::Migration[5.2]
  def change
    create_table :claps do |t|
      t.references :blog, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
