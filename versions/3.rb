def _upgrade user
  inbox = MailFolder.new
  inbox.title = 'Doručená pošta'
  inbox.user = user
  inbox.type = 'inbox'
  inbox.save
  outbox = MailFolder.new
  outbox.title = 'Odeslaná pošta'
  outbox.user = user
  outbox.type = 'outbox'
  outbox.save
end