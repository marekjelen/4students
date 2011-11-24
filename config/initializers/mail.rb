if ENV['RAILS_ENV'] == 'development'
  ActionMailer::Base.delivery_method = :sendmail
  ActionMailer::Base.sendmail_settings = {
          :location       => 'F:\Applications\msmtp\sendmail.exe',
          :arguments      => '-i -t'
  }
else
  ActionMailer::Base.delivery_method = :sendmail
  ActionMailer::Base.sendmail_settings = {
          :location       => '/usr/sbin/sendmail',
          :arguments      => '-i -t'
  }
end