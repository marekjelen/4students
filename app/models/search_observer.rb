class SearchObserver < ActiveRecord::Observer
  observe :club_message, :mail_message

  def after_update(object)
    do_index(object)
  end

  def after_save(object)
    do_index(object)
  end

  def after_destroy(object)
    undo_index(object)
  end

  def do_index(object)
    if object and object.respond_to? :fulltext_index
      object.fulltext_index
    end
  end

  def undo_index(object)
    
  end
end
