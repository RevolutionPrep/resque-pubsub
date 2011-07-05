module Resque
  module Plugins
    module Pubsub
      class Configuration
        
        def self.logger
          @logger ||= Logger.new(STDOUT)
        end
        
        def self.logger=(logger)
          @logger = logger
        end

      end
    end
  end
end