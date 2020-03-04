module CarrierWave
  module MiniMagick
    def quality(percentage)
      manipulate! do |img|
        img.quality(percentage.to_s)
        img = yield(img) if block_given?
        img
      end
    end
  end
end

CarrierWave.configure do |config|
  config.fog_credentials = {
  	provider: 'Google',
  	google_storage_access_key_id: Rails.application.credentials.google_storage_key_id,
  	google_storage_secret_access_key: Rails.application.credentials.google_storage_secret_key,
    #region: 'asia-northeast1'
  }
  config.fog_directory = 'rails-2gaijin-storage'
end