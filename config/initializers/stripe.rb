Rails.configuration.stripe = {
	publishable_key: Rails.application.credentials.stripe_publishable_key,
	secret_key: Rails.application.credentials.stripe_secret_key
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
StripeEvent.signing_secret = Rails.application.credentials.stripe_signing_secret

StripeEvent.configure do |events|
  events.subscribe 'payment_intent.', Stripe::InvoiceEventHandler.new
end