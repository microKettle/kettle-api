class AuthenticationController < ApplicationController
	skip_before_action :authenticate_request

	def authenticate
		command = AuthenticateUser.call(params[:email], params[:password])
		if command.success?
			return render json: { auth_token: command.result }, status: :created
		end
		
		render json: { error: command.errors }, status: :unauthorized
	end
end