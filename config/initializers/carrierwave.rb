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
  	google_storage_access_key_id: 'GOOGKDY6A4UK2PYZZKS6EKNB',
  	google_storage_secret_access_key: 'ZpagqElrSvPteUPwYGZL7CTp07y2bFq9r9pj63Jw'
  }
  config.fog_directory = 'rails-2gaijin-storage'
end