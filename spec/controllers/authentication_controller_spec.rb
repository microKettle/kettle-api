require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
	it 'authenticate with correct credentials should return response 201 and a token' do
		user = User.create(firstname: 'John', lastname: 'Deer', email: 'john.deer@mail.net', password: 'secret')
		
		post :authenticate, params: { email: 'john.deer@mail.net', password: 'secret' }
		expect(response).to have_http_status(:created)
		decoded_payload = ActiveSupport::JSON.decode response.body
		decoded_token = JsonWebToken.decode(decoded_payload['auth_token'])
		expect(decoded_token[:user_id]).to be(user.id)
	end

	it 'authenticate with wrong credentials should return response 401' do
		user = User.create(firstname: 'John', lastname: 'Deer', email: 'john.deer@mail.net', password: 'secret')
		
		post :authenticate, params: { email: 'john.deer@mail.net', password: 'wrong' }
		expect(response).to have_http_status(:unauthorized)
	end

	it 'authenticate with no credentials should return response 401' do
		post :authenticate
		expect(response).to have_http_status(:unauthorized)
	end
end
