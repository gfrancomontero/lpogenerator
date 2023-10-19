# frozen_string_literal: true

class AddFieldsToDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :documents, :address, :string, null: false
    add_column :documents, :year, :string, null: false
  end
end
