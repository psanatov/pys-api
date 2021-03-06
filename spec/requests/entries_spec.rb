# spec/requests/entries_spec.rb
require 'rails_helper'

RSpec.describe 'Entries API', type: :request do
  # add owner
  let(:user) { create(:user) }
  # initialize test data 
  let!(:entries) { create_list(:entry, 10, created_by: user.id) }
  let(:entry_id) { entries.first.id }
  # authorize request
  let(:headers) { valid_headers }


  # Test suite for GET /entries
  describe 'GET /entries' do
    # make HTTP get request before each example
    before { get '/entries', params: {}, headers: headers }

    it 'returns entries' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /entries/:id
  describe 'GET /entries/:id' do
    before { get "/entries/#{entry_id}", params: {}, headers: headers }

    context 'when the record exists' do
      it 'returns the entry' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(entry_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:entry_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Entry/)
      end
    end
  end

  # Test suite for POST /entries
  describe 'POST /entries' do
    # valid payload
    let(:valid_attributes) do
      { title: 'Learn Elm', created_by: user.id.to_s }.to_json
    end

    context 'when the request is valid' do
      before { post '/entries', params: valid_attributes, headers: headers }

      it 'creates a entry' do
        expect(json['title']).to eq('Learn Elm')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      let(:valid_attributes) { { title: nil }.to_json }
      before { post '/entries', params: valid_attributes, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Title can't be blank/)
      end
    end
  end

  # Test suite for PUT /entries/:id
  describe 'PUT /entries/:id' do
    let(:valid_attributes) { { title: 'Shopping' }.to_json }

    context 'when the record exists' do
      before { put "/entries/#{entry_id}", params: valid_attributes, headers: headers }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /entries/:id
  describe 'DELETE /entries/:id' do
    before { delete "/entries/#{entry_id}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
