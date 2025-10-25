if defined?(Rack::Attack)
  class Rack::Attack
    # Allow localhost
    safelist('allow-localhost') do |req|
      [ '127.0.0.1', '::1' ].include?(req.ip)
    end

    # Generic API throttle per IP
    throttle('api/req/ip', limit: ENV.fetch('RACK_ATTACK_REQ_LIMIT_PER_MIN', '60').to_i, period: 1.minute) do |req|
      req.ip if req.path.start_with?('/api/')
    end

    # Tighter throttle for login
    throttle('logins/ip', limit: ENV.fetch('RACK_ATTACK_LOGIN_LIMIT', '5').to_i, period: 20.seconds) do |req|
      req.ip if req.path == '/api/v1/login' && req.post?
    end

    # Tighter throttle for signup
    throttle('signups/ip', limit: ENV.fetch('RACK_ATTACK_SIGNUP_LIMIT', '5').to_i, period: 1.minute) do |req|
      req.ip if req.path == '/api/v1/signup' && req.post?
    end

    self.throttled_responder = lambda do |_request|
      [ 429,
        { 'Content-Type' => 'application/json' },
        [ { errors: [ 'Too many requests' ] }.to_json ] ]
    end
  end
end
