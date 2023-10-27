require 'rspec/autorun'
require 'dotenv'
require_relative '../app/controllers/comments'

describe CommentController do
  let(:controller) { CommentController.new }

  before(:all) do
    require_relative '../config/environment'
    require_relative '../app/models/db_init'
  end

  it 'gets a comment from db' do
    result = controller.get_comment(2)  
    expect(result).to have_key(:ok)
    expect(result).to have_key(:data)
    expect(result[:ok]).to be true
    expect(result[:data]).to be_truthy
    expect(result[:data][:content]).to be_truthy
  end

  it 'gets all comments from db' do
    result = controller.get_all_comments
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be true
    expect(result).to have_key(:data)
    expect(result[:data]).to be_truthy
    expect(result[:data].length).to be >= 0
  end

  it 'adds a comment to db' do
    comment = { 'article_id' => 2, 'content' => 'Test comment' }  
    result = controller.create_comment(comment)
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be true
    expect(result).to have_key(:obj)
    expect(result[:obj]).to be_truthy
  end

  it 'updates a comment in db' do
    comment = { 'content' => 'Updated comment content' }
    result = controller.update_comment(2, comment)  
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be true
    expect(result).to have_key(:obj)
    expect(result[:obj]).to be_truthy
  end

  it 'deletes a comment from db' do
    result = controller.delete_comment(2)
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be true
  end

  it 'tries to delete a non-existent comment' do
    result = controller.delete_comment(99)
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be false
  end
end
