class AddTemplateIdToDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :documents, :template_id, :integer, default: 1
  end
end
