require 'sinatra/base'
require 'rack/test'
require 'rspec/autorun'
require 'json'
require 'base64'
require_relative '../app/middleware/auth'
require_relative './helpers/headers'
require_relative '../app/routes/home'
require_relative '../app/routes/comments'

describe CommentRoutes do
  include Rack::Test::Methods

  let(:app) { CommentRoutes.new }
  let(:auth_header) { prepare_headers(HeaderType::HTTP_AUTH) }
  let(:content_type_header) { prepare_headers(HeaderType::CONTENT_TYPE) }

  before(:all) do
    require_relative '../config/environment'
    require_relative '../app/models/db_init'
  end

  context 'testing the get comments endpoint GET /' do
    let(:response) { get '/', nil, auth_header }

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('comments')
      expect(hashed_response['comments'].length).to be >= 0
    end
  end

  context 'testing the get single comment endpoint GET /:id' do
    let(:response) { get '/1', nil, auth_header }

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('comment')
      expect(hashed_response['comment']).to be_truthy
    end
  end

  context 'testing the create comment endpoint POST /' do
    let(:response) do
      post '/', JSON.generate('article_id' => 1, 'content' => 'New comment'),
      content_type_header.merge(auth_header)
    end

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('msg')
      expect(hashed_response['msg']).to eq('Comment created')
    end
  end

  context 'testing the update comment endpoint PUT /:id' do
    let(:response) do
      put '/1', JSON.generate('content' => 'Updated comment content'),
      content_type_header.merge(auth_header)
    end

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('msg')
      expect(hashed_response['msg']).to eq('Comment updated')
    end
  end

  context 'testing the delete comment endpoint DELETE /:id' do
    let(:response) { delete '/1', nil, auth_header }

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('msg')
      expect(hashed_response['msg']).to eq('Comment deleted')
    end
  end
end
