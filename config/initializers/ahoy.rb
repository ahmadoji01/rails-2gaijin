class Ahoy::Store < Ahoy::DatabaseStore
  mattr_accessor :auto_mount
  self.auto_mount = false
end

# set to true for JavaScript tracking
Ahoy.api = false
