# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Registration', type: :request do
  let(:user_params_one) do
    {
      email: 'user@example.com',
      password: '12345678'
    }
  end

  let(:user_params_two) do
    {
      email: 'test@example.com',
      password: '12345678'
    }
  end

  let(:sign_up_url) { '/auth' }

  describe 'POST /auth' do
    context 'when signup params are valid' do
      before { post sign_up_url, params: user_params_one }

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns authentication header with right attributes' do
        expect(response.headers['access-token']).to be_present
      end

      it 'returns client in authentication header' do
        expect(response.headers['client']).to be_present
      end

      it 'returns expiry in authentication header' do
        expect(response.headers['expiry']).to be_present
      end

      it 'returns uid in authentication header' do
        expect(response.headers['uid']).to be_present
      end

      it 'returns status success' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['status']).to eq('success')
      end

      it 'creates new user' do
        expect do
          post sign_up_url, params: user_params_two
        end.to change(User, :count).by(1)
      end
    end

    context 'when signup params are invalid' do
      before { post sign_up_url }

      it 'returns unprocessable entity 422' do
        expect(response.status).to eq 422
      end
    end
  end
end
