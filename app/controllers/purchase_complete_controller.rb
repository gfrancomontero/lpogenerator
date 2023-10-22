# frozen_string_literal: true

class PurchaseCompleteController < ApplicationController
  def index
    document_id = params[:document_id].to_i
    received_token = params[:token]

    transaction_success(document_id) if current_user.purchase_token == received_token
    redirect_to purchased_documents_path
  end

  private

  def transaction_success(document_id)
    # we must reset the token so it cant be used again
    current_user.update(purchase_token: 'token_is_reset')

    # remove first purchased document if the user has 5 or more.
    if current_user.purchased_documents.count >= 5
      current_user.update(purchased_documents: current_user.purchased_documents.drop(1))
    end

    user_docs = current_user.purchased_documents

    user_docs << document_id unless user_docs.include?(document_id)
    current_user.save
  end
end
