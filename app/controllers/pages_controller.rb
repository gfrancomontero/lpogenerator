# frozen_string_literal: true

class PagesController < ApplicationController
  def home; end

  def purchased_documents
    if current_user

      documents = []
      current_user.purchased_documents.each do |document|
        documents << Document.find(document)
      end
      @documents = documents

    else
      redirect_to root_path
    end
  end
end
