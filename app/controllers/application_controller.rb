class ApplicationController < ActionController::API
	before_action :authenticate_request
	attr_reader :current_user

	def authenticate_request
		command = AuthorizeRequest.call(request.headers)
		if command.success? == true
			@current_user = command.result
			return
		end

		render json: { error: 'Not authorized' }, status: 401
	end
end
