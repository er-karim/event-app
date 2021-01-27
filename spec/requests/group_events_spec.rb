require 'rails_helper'

RSpec.describe 'Event Groups API V1', type: :request do
  # initialize test data
  let!(:group_events) { create_list(:group_event, 10) }
  let(:group_event_id) { group_events.first.id }

  # Test suite for GET /api/v1/group_events
  describe 'GET /api/v1/group_events' do
    # make HTTP get request before each example
    before { get '/api/v1/group_events' }

    it 'returns group events' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /api/v1/group_events/:id
  describe 'GET /api/v1/group_events/:id' do
    before { get "/api/v1/group_events/#{group_event_id}" }

    context 'when the record exists' do
      it 'returns the group event' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(group_event_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:group_event_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/{\"message\":\"Couldn't find GroupEvent with 'id'=100\"}/)
      end
    end
  end

  # Test suite for POST /api/v1/group_events
  describe 'POST /api/v1/group_events' do
    # valid payload
    let(:valid_attributes) { { name: 'Event name' } }

    context 'when the request is valid' do
      before { post '/api/v1/group_events', params: valid_attributes }

      it 'creates a group event' do
        expect(json['name']).to eq('Event name')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/group_events', params: { name: 'Event name', is_draft: false } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/{\"message\":\"Validation failed: Description can't be blank, Location can't be blank, Duration can't be blank, Start at can't be blank\"}/)
      end
    end
  end

  # Test suite for PUT /api/v1/group_events/:id
  describe 'PUT /api/v1/group_events/:id' do
    let(:valid_attributes) { { name: 'Event name' } }

    context 'when the record exists' do
      before { put "/api/v1/group_events/#{group_event_id}", params: valid_attributes }

      it 'updates the record' do
        expect(json['name']).to eq('Event name')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for DELETE /api/v1/group_events/:id
  describe 'DELETE /api/v1/group_events/:id' do
    before { delete "/api/v1/group_events/#{group_event_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
