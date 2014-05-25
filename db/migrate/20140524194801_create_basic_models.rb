class CreateBasicModels < ActiveRecord::Migration
  def change

    add_column :users, :name, :string, null: false    

    create_table :identities do |t|
      t.string     :provider, null: false
      t.string     :uid,      null: false
      t.string     :url
      t.string     :name
      t.string     :email
      t.string     :token
      t.string     :secret
      t.string     :handle
      t.belongs_to :user
      t.timestamps
    end
    add_foreign_key :identities, :users    

    create_table :batches do |t|
      t.string     :name, null: false
      t.integer    :batch_size, null: false
      t.boolean    :active, null: false, default: false
      t.date       :starts_at, null: false
      t.date       :ends_at, null: false
      t.text       :application_questions
      t.timestamps
    end

    create_table :applications do |t|
      t.belongs_to :user
      t.belongs_to :batch
      t.text       :application_answers
      t.boolean    :accepted, :null => false, :default => false
      t.integer    :rating 
      t.timestamps
    end
    add_foreign_key :applications, :users
    add_foreign_key :applications, :batches

  end
end
