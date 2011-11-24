class MailMessage < ActiveRecord::Base
  belongs_to  :sender, :class_name => 'User'
  belongs_to  :recipient, :class_name => 'User'
  belongs_to  :folder, :class_name => 'MailFolder'

  def fulltext_index
    SOLR.add( :id => 'mail_message-' + id.to_s,
	      :type => 'mail_message',
	      :mail_message_sender_id => sender_id,
	      :mail_message_sender_name => sender.display,
	      :mail_message_recipient_id => recipient_id,
	      :mail_message_recipient_name => recipient.display,
	      :mail_message_subject => subject,
	      :mail_message_body => body,
	      :mail_message_date => created_at.strftime(SOLR_DATESTRING))
    SOLR.commit
  end
end
