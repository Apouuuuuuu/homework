require_relative '../controllers/articles'

class ArticleRoutes < Sinatra::Base
  use AuthMiddleware

  def initialize
    super
    @articleCtrl = ArticleController.new
  end

  before do
    content_type :json
  end

  ###################################
  # Old get('/')
  # get('/') do
  #   summmary = @articleCtrl.get_batch

  #   if !(summary[:ok])
  #     { articles: summary[:data] }.to_json
  #   else
  #     { msg: 'Could not get articles.' }.to_json
  #   end
  # end


  # New get('/')
  get('/') do
    summary = @articleCtrl.get_batch
  
    if summary[:ok]
      { articles: summary[:data] }.to_json
    else
      { msg: 'Could not get articles.' }.to_json
    end
  end
  
  

  ###################################
  # # Old get('/:id')
  # get('/:id') do
    
  # end

  
  # New get('/:id')
  get('/:id') do
    begin
      summary = @articleCtrl.get_article(params[:id])
      if summary[:ok]
        { article: summary[:data] }.to_json
      else # even if article isnt find, send status 200
        { msg: 'Article not found.' }.to_json
      end
    rescue => e
      status 501
      { msg: "Error: #{e.message}" }.to_json
    end
end


  ###################################
  # Old post('/')
  # post('/') do
  #   payload = JSON.parse(request.body.read)
  #   summary = @articleCtrl.update_article(payload)

  #   if summary[:ok]
  #     { msg: 'Article updated' }.to_json
  #   else
  #     { msg: summary[:msg] }.to_json
  #   end
  # end

  # New post('/')
  post('/') do
    payload = JSON.parse(request.body.read)
    summary = @articleCtrl.create_article(payload) 
  
    if summary[:ok]
      { msg: 'Article created' }.to_json
    else
      { msg: summary[:msg] }.to_json
    end
  end
  

  ###################################
  # Old put('/:id')
  # put('/:id') do
  #   payload = JSON.parse(request.body.read)
  #   summary = @articleCtrl.uptade_article params['ids'], payload

  #   if summary[:ok]
  #   else
  #     { msg: summary[:msg] }.to_json
  #   end
  # end

  # New put('/:id')
  put('/:id') do
    payload = JSON.parse(request.body.read)
    summary = @articleCtrl.update_article(params['id'], payload) 
  
    if summary[:ok]
      { msg: 'Article updated' }.to_json
    else
      { msg: summary[:msg] }.to_json
    end
  end

  
  ###################################
  # Old delete('/:id')
#   delete('/:id') do
#     summary = self.delete_article params['id']

#     if summary[:ok]
#       { msg: 'Article deleted' }.to_json
#     else
#       { mgs: 'Article does not exist' }.to_bson
#     end
#   end
# end

  # new delete('/:id')
  delete('/:id') do
    summary = @articleCtrl.delete_article params['id']
  
    if summary[:ok]
      { msg: 'Article deleted' }.to_json
    else
      { msg: 'Article does not exist' }.to_json
    end
  end
end