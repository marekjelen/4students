module MailMessagesWrapper
  class MailMessagesWrapper
    def initialize(ids)
      @hash_array = Array.new
      @hash_hash = Hash.new
 
      ids.each do |id|
        message = MailMessage.find_by_id(id)
        hash = Digest::MD5.hexdigest(message.sender_id.to_s + message.subject + message.body)
  
        if @hash_array.include?(hash)
          @hash_hash[hash].add_recipient(message.recipient)
        else
          m = MailMessageWrapper.new(hash)
          m.sender = message.sender
          m.subject = message.subject
          m.body = message.body
          m.created_at = message.created_at
          m.add_recipient(message.recipient)
  
          @hash_array.push(hash)
          @hash_hash[hash] = m
        end
      end
    end
 
    def messages
      result = Array.new
 
      @hash_array.each do |hash|
        result.push(@hash_hash[hash])
      end
 
      return result
    end
  end

  class MailMessageWrapper
    attr_reader :hash, :recipients
    attr_accessor :subject, :body, :sender, :created_at

    def initialize(hash)
      @hash = hash
      @recipients = Array.new
    end

    def add_recipient(recipient)
      @recipients.push(recipient)
    end

    def recipients_string
      recipients = Array.new
      @recipients.each { |r| recipients.push(r.display) }
      return recipients.uniq.join(', ')
    end
  end
end
