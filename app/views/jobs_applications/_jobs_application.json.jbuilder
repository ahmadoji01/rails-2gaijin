json.extract! jobs_application, :id, :age, :nationality, :expiry, :addresslat, :addresslong, :phone, :email, :created_at, :updated_at
json.url jobs_application_url(jobs_application, format: :json)
