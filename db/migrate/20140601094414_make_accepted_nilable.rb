class MakeAcceptedNilable < ActiveRecord::Migration
  def change
    change_column :applications, :accepted, :boolean, null: true
  end
end
