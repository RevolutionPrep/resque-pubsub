module Resque
  module Plugins
    module Pubsub
      class Exchange
        
        @queue = :subscription_requests

        class << self

          def redis
            return @redis if @redis
            client_to_copy = Resque.redis.client
            redis_new = Redis.new(:host => client_to_copy.host, :port => client_to_copy.port, :thread_safe => true, :db => client_to_copy.db)
            Configuration.logger.info "[Exchange] making a redis in exchange, namespace will be #{@pubsub_namespace}"
            @redis = Redis::Namespace.new(@pubsub_namespace || 'resque:pubsub', :redis => redis_new)
          end

          def perform(subscription_info)
            Configuration.logger.info '[Exchange] handling a subscription on the exchange'
            Configuration.logger.info "[Exchange] requested subscription is #{subscription_info.inspect}"
            Configuration.logger.info "[Exchange] namespace is #{Exchange.redis.namespace}"
            Exchange.redis.sadd("#{subscription_info["topic"]}_subscribers", { :class => subscription_info['class'], :namespace => subscription_info['namespace'] }.to_json)
          end

          def pubsub_namespace
            @pubsub_namespace
          end

          def pubsub_namespace=(namespace)
            @pubsub_namespace = namespace
            @redis.client.disconnect if @redis
            @redis = nil
          end

        end

      end
    end
  end
end
