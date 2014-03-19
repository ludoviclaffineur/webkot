class CommentableHandler

  def self.load_commentable(request)
    type, id = request.path.split('/')[1, 2]
    @commentable = type.singularize.classify.constantize.find(id)
  end
end