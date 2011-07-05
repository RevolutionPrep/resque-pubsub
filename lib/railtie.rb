module Resque
  module Plugins
    module Pubsub
      class Railtie < Rails::Railtie

        initializer "polaris_resource.configure_logger", :after => :initialize_logger do |app|
          Configuration.logger = Rails.logger
        end

      end
    end
  end
end