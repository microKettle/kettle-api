class AuthorizeRequest
	prepend SimpleCommand

	def initialize(headers= {} )
		@headers = headers
	end

	def call
		user
	end

	private

	attr_reader :headers

	def user
		token = extract_http_auth
		if token != nil
			decoded_token = decode_auth_token(token)
			if decoded_token != nil
				user = User.find_by_id(decoded_token[:user_id])
				if user != nil
					return user
				end
			end
			errors.add(:token, 'Invalid token')
			return nil
		end 

		errors.add(:token, 'Missing token')
		nil
	end

	def decode_auth_token(token)
		return JsonWebToken.decode(token)
	end

	def extract_http_auth
		if headers['Authorization'].present?
			return headers['Authorization'].split(' ').last
		end
		nil
	end
end