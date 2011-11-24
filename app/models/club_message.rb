class ClubMessage < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :club

  def fulltext_index
    u = user
    SOLR.add( :id => 'club_message-' + id.to_s,
	      :type => 'club_message',
	      :club_message_user_id => user_id,
	      :club_message_user => u.display,
	      :club_message_username => u.username,
	      :club_message_club_id => club_id,
	      :club_message_text => message,
              :club_message_date => created_at.strftime(SOLR_DATESTRING))
    SOLR.commit
  end
end
