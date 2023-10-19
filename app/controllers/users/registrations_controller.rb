# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :permit_params

    def after_sign_up_path_for(resource)
      if params[:user][:document_id].present?
        document_path(params[:user][:document_id])
      else
        super(resource)
      end
    end

    def permit_params
      params.permit(:document_id)
    end
  end
end
