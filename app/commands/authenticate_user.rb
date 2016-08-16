class AuthenticateUser
	prepend SimpleCommand

	def initialize(email, password)
		@email = email
		@password = password
	end

	def call
		if user != nil
			JsonWebToken.encode(user_id: user.id)
		end
	end

	private

	attr_accessor :email, :password

	def user
		user = User.find_by_email(email)
		if user != nil && user.authenticate(password) != false
			return user
		end

		errors.add :user_authentication, 'invalid credentials'
		nil
	end
end