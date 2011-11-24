class Mailer < ActionMailer::Base
  
  def registration(user, sent_at = Time.now)
    subject    'Registrace na 4Students.cz'
    recipients user.email
    from       'info@4students.cz'
    sent_on    sent_at    
    body       :user => user
  end

end
