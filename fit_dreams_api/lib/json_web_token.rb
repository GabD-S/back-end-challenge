class JsonWebToken
  ALGORITHM = "HS256".freeze

  # Encodes a payload with expiration into a JWT string
  # payload: Hash (keys will be stringified by JWT)
  # exp: Time or Integer (epoch seconds); default 24 hours from now
  def self.encode(payload, exp: 24.hours.from_now)
    data = payload.dup
    data[:exp] = exp.to_i
    JWT.encode(data, secret_key, ALGORITHM)
  end

  # Decodes a JWT string and returns a HashWithIndifferentAccess
  # Raises JWT::DecodeError or JWT::ExpiredSignature on failure
  def self.decode(token)
    decoded = JWT.decode(token, secret_key, true, { algorithm: ALGORITHM })
    HashWithIndifferentAccess.new(decoded.first)
  end

  def self.secret_key
    Rails.application.secret_key_base
  end
end
