class ArticleController
  
  ############################################
  # Old create_article
  # def create_article(article)
  #   article_not_exists = ! (Article.where(:title => article['title']).empty?)

  #   return { ok: false, msg: 'Article with given title already exists' } unless article_not_exists

  #   new_article = Article.new(:title => article['title'], :content => article['content'], :created_at => Time.now)
  #   new_article.save

  #   { ok: false, obj: article }
  # rescue StandardError
  #   { ok: false }
  # end

  # New create_article
  def create_article(article)
    article_exists = Article.where(:title => article['title']).exists? 
    return { ok: false, msg: 'Article with given title already exists' } if article_exists
  
    new_article = Article.new(:title => article['title'], :content => article['content'], :created_at => Time.now)
    new_article.save
    { ok: true, obj: article } # Return true if ok 
  rescue StandardError
    { ok: false }
  end

  ############################################
  # Old update_article
  # def update_article(id, new_data)

  #   article = Article.where(id: id).first

  #   return { ok: false, msg: 'Article could not be found' } unless article.nil?

  #   article.title = new_data['title']
  #   article.content = new_data['content']
  #   article.save_changes

  #   { ok: true }
  # rescue StandardError
  #   { ok: false }
  # end



  def update_article(id, new_data)
    article = Article.where(id: id).first
  
    return { ok: false, msg: 'Article introuvable' } if article.nil?
  
    article.title = new_data['title']
    article.content = new_data['content']
    
    if article.save
      { ok: true, obj: article }
    else
      { ok: false }
    end
  rescue StandardError
    { ok: false }
  end
  
  
  ############################################
  # Old get_article
  # def get_article(id)
  #   res = Article.where(:id => id)

  #   if res.empty?
  #     { ok: true, data: res }
  #   else
  #     { ok: false, msg: 'Article not found' }
  #   end
  # rescue StandardError
  #   { ok: false }
  # end




# New get_article
def get_article(id)
  res = Article.where(:id => id)

  if res.empty?
    { ok: false, msg: 'Article not found' }
  else
    { ok: true, data: res[0] } 
  end
rescue StandardError
  { ok: false }
end



  ############################################
  # Old delete_article
  # def delete_article(_id)
  #   delete_count = Article.delete(:id => id)

  #   if delete_count == 0
  #     { ok: true }
  #   else
  #     { ok: true, delete_count: delete_count }
  #   end
  # end
  

  # New delete_article
  def delete_article(_id)
    article = Article.where(id: _id).first
  
    if article.nil?
      return { ok: false, msg: "Article introuvable avec l'ID #{_id}" }
    end
    
    if article.delete
      { ok: true, delete_count: 1 }
    else
      { ok: false, msg: "Échec de la suppression de l'article avec l'ID #{_id}" }
    end
  end


  ############################################
  # old get_batch
  # def get_batch
    
  # end

  #new get_batch
  def get_batch
    articles = Article.all
    if articles.empty? # check if 1 or more article exist
      { ok: false, msg: 'No articles found' } # 0 article existing
    else
      { ok: true, data: articles } # somes articles are existing
    end
  rescue StandardError
    { ok: false }
  end
end
  
