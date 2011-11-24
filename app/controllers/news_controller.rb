class NewsController < ApplicationController

  before_filter   :secure_controller
  
  def index
    if not params[:id]
      @entries = FeedEntry.find_by_sql '
        SELECT feed_entries.* FROM feed_entries
          JOIN feeds ON feed_entries.feed_id = feeds.id
          JOIN feed_subscribtions ON feeds.id = feed_subscribtions.feed_id
          JOIN users ON feed_subscribtions.user_id = users.id
          ORDER BY feed_entries.published DESC LIMIT 0,100
      '
    else
      @entries = FeedEntry.find :all, :conditions => { :feed_id => params[:id] }, :order => 'published DESC', :limit => 100 
    end
    @feeds = Feed.find_by_sql '
        SELECT feeds.*  FROM feeds
          JOIN feed_subscribtions ON feeds.id = feed_subscribtions.feed_id
          JOIN users ON feed_subscribtions.user_id = users.id
      '
  end

  def add
    @link = params[:link]
    if @link
      parser = XML::Parser.file(@link)
      doc = parser.parse
      @title = doc.find_first('/rss/channel/title').inner_xml
      @web_link = doc.find_first('/rss/channel/link').inner_xml
      @description = doc.find_first('/rss/channel/description').inner_xml
      @found = true
    end
  end

  def register
    feed = Feed.find :first, :conditions => { :url => params[:link]}
    if not feed
      feed = Feed.new
      feed.title = params[:title]
      feed.url = params[:link]
      feed.description = params[:description]
      feed.save
    end
    sub = FeedSubscribtion.new
    sub.user = @user
    sub.feed = feed
    sub.save
    return redirect_to(:action => 'index')
  end

end
