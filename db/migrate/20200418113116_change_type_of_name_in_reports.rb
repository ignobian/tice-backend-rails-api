class ChangeTypeOfNameInReports < ActiveRecord::Migration[5.2]
  def change
    change_column :reports, :name, :string
  end
end
