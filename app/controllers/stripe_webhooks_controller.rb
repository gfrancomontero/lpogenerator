# frozen_string_literal: true

# app/controllers/stripe_webhooks_controller.rb
class StripeWebhooksController < ApplicationController
  protect_from_forgery except: :handle_event

  def handle_event
    byebug

    payload = request.body.read
    event = Stripe::Webhook.construct_event(payload, request.headers['HTTP_STRIPE_SIGNATURE'],
                                            ENV['STRIPE_WEBHOOK_SECRET'])

    case event.type
    when 'payment_intent.succeeded'
      handle_successful_payment(event.data.object)
    when 'payment_intent.payment_failed'
      handle_failed_payment(event.data.object)
    end

    head :ok
  rescue JSON::ParserError, Stripe::SignatureVerificationError
    head :bad_request
  end

  private

  def handle_successful_payment(payment_intent)
    # Add the purchased PDF to the user's database of purchased documents.
    # Mark the PDF as purchased by the user.
  end

  def handle_failed_payment(_payment_intent)
    # Redirect the user to a payment failed page.
    redirect_to payment_failed_path
  end
end
