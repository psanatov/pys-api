# app/requests/items_spec.rb
require 'rails_helper'

RSpec.describe 'Items API' do
  # Initialize the test data
  let!(:entry) { create(:entry) }
  let!(:items) { create_list(:item, 20, entry_id: entry.id) }
  let(:entry_id) { entry.id }
  let(:id) { items.first.id }

  # Test suite for GET /entries/:entry_id/items
  describe 'GET /entries/:entry_id/items' do
    before { get "/entries/#{entry_id}/items" }

    context 'when entry exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all entry items' do
        expect(json.size).to eq(20)
      end
    end

    context 'when entry does not exist' do
      let(:entry_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Entry/)
      end
    end
  end

  # Test suite for GET /entries/:entry_id/items/:id
  describe 'GET /entries/:entry_id/items/:id' do
    before { get "/entries/#{entry_id}/items/#{id}" }

    context 'when entry item exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the item' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when entry item does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  # Test suite for POST /entries/:entry_id/items
  describe 'POST /entries/:entry_id/items' do
    let(:valid_attributes) { { name: 'Visit Narnia', visible: false } }

    context 'when request attributes are valid' do
      before { post "/entries/#{entry_id}/items", params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/entries/#{entry_id}/items", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  # Test suite for PUT /entries/:entry_id/items/:id
  describe 'PUT /entries/:entry_id/items/:id' do
    let(:valid_attributes) { { name: 'Mozart' } }

    before { put "/entries/#{entry_id}/items/#{id}", params: valid_attributes }

    context 'when item exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the item' do
        updated_item = Item.find(id)
        expect(updated_item.name).to match(/Mozart/)
      end
    end

    context 'when the item does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  # Test suite for DELETE /entries/:id
  describe 'DELETE /entries/:id' do
    before { delete "/entries/#{entry_id}/items/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
