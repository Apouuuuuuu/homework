class CommentController
  
  # Existing method for creating a comment
  def create_comment(comment)
    comment_exists = Comment.where(:content => comment['content']).exists? 
    return { ok: false, msg: 'Comment with given content already exists' } if comment_exists

    new_comment = Comment.new(:content => comment['content'], :article_id => comment['article_id'], :created_at => Time.now)
    new_comment.save
    { ok: true, obj: comment } 
  rescue StandardError
    { ok: false }
  end

  # Existing method for retrieving a single comment by ID
  def get_comment(id)
    res = Comment.where(:id => id)
  
    if res.empty?
      { ok: false, msg: 'Comment not found' }
    else
      { ok: true, data: res[0] }
    end
  rescue StandardError => e
    { ok: false, msg: e.message }
  end
  
  # Existing method for deleting a comment by ID
  def delete_comment(_id)
    comment = Comment.where(id: _id).first
    if comment.nil?
      return { ok: false, msg: "Comment not found with ID #{_id}" }
    end
    if comment.delete
      { ok: true, delete_count: 1 }
    else
      { ok: false, msg: "Failed to delete the comment with ID #{_id}" }
    end
  rescue StandardError
    { ok: false }
  end

  # Existing method for retrieving all comments
  def get_all_comments
    comments = Comment.all
    if comments.empty?
      { ok: false, msg: 'No comments found' }
    else
      { ok: true, data: comments }
    end
  rescue StandardError
    { ok: false }
  end
  

  # New method for updating a comment by ID
  def update_comment(id, new_data)
    comment = Comment.where(id: id).first

    return { ok: false, msg: 'Comment not found' } if comment.nil?

    comment.content = new_data['content']

    if comment.save
      { ok: true, obj: comment }
    else
      { ok: false }
    end
  rescue StandardError
    { ok: false }
  end

end
