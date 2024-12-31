if Rails.env.development? && ENV['START_REDIS'] != 'false'
  begin
    redis = Redis.new
    redis.ping
  rescue Errno::ECONNREFUSED
    puts "Redis server not running, starting it now..."
    # Start Redis server manually if it's not running
    system("redis-server --daemonize yes")
    sleep 2 # Wait for Redis to start
  end
end
