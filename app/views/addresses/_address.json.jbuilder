json.extract! address, :id, :full_address, :apartment, :city, :state, :postal_code, :created_at, :updated_at
json.url address_url(address, format: :json)
