# frozen_string_literal: true

# app/services/stripe_service.rb

class StripeService
  def initialize(user)
    @user = user
  end

  def create_payment_intent(_amount_in_cents, _document_id, _redirect_url)
    # Access the Stripe secret key from the configuration
    # This is your test secret API key.

    Stripe.api_key = Rails.configuration.stripe[:secret_key]
    if Rails.env.development?
      success = "#{_redirect_url}/purchase_complete?token=#{@user.purchase_token}&document_id=#{_document_id}"
    end
    failure = "#{_redirect_url}/documents/#{_document_id}?payment=retry" if Rails.env.development?
    Stripe::Checkout::Session.create({
                                       line_items: [{
                                         # Provide the exact Price ID (e.g. pr_1234) of the product you want to sell
                                         price: 'price_1O32AEAbiuoSKNFwINvTgLms',
                                         quantity: 1
                                       }],
                                       mode: 'payment',
                                       success_url: success,
                                       cancel_url: failure,
                                       automatic_tax: { enabled: true }
                                     })
  end
end

# Test catastral 3728112UF2432N0001KK
# Test catastral 4618101UF2441N0315ZW
