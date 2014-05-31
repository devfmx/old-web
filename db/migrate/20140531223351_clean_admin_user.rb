class CleanAdminUser < ActiveRecord::Migration
  def up
    %w[
      email
      encrypted_password
      reset_password_token
      reset_password_sent_at
      remember_created_at
      sign_in_count
      current_sign_in_at
      last_sign_in_at
      current_sign_in_ip
      last_sign_in_ip
      created_at
      updated_at
    ].each { |c| remove_column :admin_users, c.to_sym }
  end
end
