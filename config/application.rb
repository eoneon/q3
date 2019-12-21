require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Q3
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    #config.autoload_paths += %W(#{config.root}/app/models/product_part)
    config.autoload_paths += %W(#{config.root}/app/models/element)
    config.autoload_paths += %W(#{config.root}/app/models/element/element_type)
    config.autoload_paths += %W(#{config.root}/app/models/element/category)
    config.autoload_paths += %W(#{config.root}/app/models/element/medium)
    config.autoload_paths += %W(#{config.root}/app/models/element/material)
    config.autoload_paths += %W(#{config.root}/app/models/element/dimension)
    config.autoload_paths += %W(#{config.root}/app/models/element/mounting)
    config.autoload_paths += %W(#{config.root}/app/models/element/edition)
    #config.autoload_paths += %W(#{config.root}/app/models/item_field)
    #config.autoload_paths += %W(#{config.root}/app/models/item_value)
    #config.autoload_paths += %W(#{config.root}/lib/element)
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
