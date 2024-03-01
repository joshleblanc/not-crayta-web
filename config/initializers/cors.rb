Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'https://unairf.itch.io/koinonia'
      resource '*', headers: :any, methods: [:get, :post, :patch, :put]
    end
end