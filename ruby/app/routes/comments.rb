require_relative '../controllers/comments'

class CommentRoutes < Sinatra::Base
  use AuthMiddleware

  def initialize
    super
    @commentCtrl = CommentController.new
  end

  before do
    content_type :json
  end

  # Get all comments
  get('/') do
    summary = @commentCtrl.get_all_comments
  
    if summary[:ok]
      { comments: summary[:data] }.to_json
    else
      { msg: 'Could not get comments.' }.to_json
    end
  end
  
  # Get a single comment by ID
  get('/:id') do
    begin
      summary = @commentCtrl.get_comment(params[:id])
      if summary[:ok]
        { comment: summary[:data] }.to_json
      else
        { comment: nil, msg: 'Comment not found.' }.to_json
      end
    rescue => e
      status 501
      { msg: "Error: #{e.message}" }.to_json
    end
  end
  
  
  

  # Create a new comment
  post('/') do
    payload = JSON.parse(request.body.read)
    summary = @commentCtrl.create_comment(payload) 
  
    if summary[:ok]
      { msg: 'Comment created' }.to_json
    else
      { msg: summary[:msg] }.to_json
    end
  end
  
  # Update a comment by ID
  put('/:id') do
    payload = JSON.parse(request.body.read)
    summary = @commentCtrl.update_comment(params['id'], payload)
  
    if summary[:ok]
      { msg: 'Comment updated' }.to_json
    else
      { msg: summary[:msg] }.to_json
    end
  end

  # Delete a comment by ID
  delete('/:id') do
    summary = @commentCtrl.delete_comment params['id']
  
    if summary[:ok]
      { msg: 'Comment deleted' }.to_json
    else
      { msg: 'Comment does not exist' }.to_json
    end
  end
end
