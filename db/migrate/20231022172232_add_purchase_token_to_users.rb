# frozen_string_literal: true

class AddPurchaseTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :purchase_token, :string, default: ''
  end
end
