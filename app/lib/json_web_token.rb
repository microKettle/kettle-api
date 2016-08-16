class JsonWebToken 
	def self.encode(payload, exp = 24.hours.from_now)
		payload[:exp] = exp.to_i
		JWT.encode(payload, Rails.application.secrets.secret_key_base)
	end

	def self.decode(token)
		payload = JWT.decode(token, Rails.application.secrets.secret_key_base)
		HashWithIndifferentAccess.new payload[0]
	rescue
		nil
	end
end