require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
	controller do
		def index; end
	end 

	it 'authenticated request should return a current user' do
		user = User.create(firstname: 'John', lastname: 'Deer', email: 'john.deer@mail.net', password: 'secret')
		command = AuthenticateUser.call(user.email, user.password)
		@request.headers['Authorization'] = command.result

		get :index
		expect(controller.current_user).to eq(user) 
		expect(response).to have_http_status(:no_content)
	end

	it 'unauthenticated request should return 401' do
		get :index
		expect(controller.current_user).to be(nil) 
		expect(response).to have_http_status(:unauthorized) 
		expect(response.body).to include_json({
			'error': 'Not authorized'
		})
	end

	it 'request with wrong authentication should return 401' do
		token = JsonWebToken.encode(user_id: 123)
		@request.headers['Authorization'] = token

		get :index
		expect(controller.current_user).to be(nil) 
		expect(response).to have_http_status(:unauthorized) 
		expect(response.body).to include_json({
			'error': 'Not authorized'
		})
	end
end
