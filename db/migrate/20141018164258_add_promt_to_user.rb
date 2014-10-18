class AddPromtToUser < ActiveRecord::Migration
  def change
    add_column :users, :prompt, :boolean, default: true
  end
end
