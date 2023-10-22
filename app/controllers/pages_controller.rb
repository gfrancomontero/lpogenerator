# frozen_string_literal: true

class PagesController < ApplicationController
  def home; end

  def purchased_documents
    if current_user
      if current_user.purchased_documents.any?
        documents = []
        current_user.purchased_documents.each do |document|
          documents << Document.find(document)
        end
        @documents = documents
      else
        @documents = []
      end

    else
      redirect_to root_path
    end
  end
end
