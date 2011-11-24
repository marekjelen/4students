class SearchController < ApplicationController
  before_filter   :secure_controller

  def club_message
    @query = params[:query]

    if @query and not @query.empty?
      query = '(' + @query + ') AND type:club_message'
      results = Array.new

      begin
        solr_result = SOLR.request('/select', :q => query)
        solr_result['response']['docs'].each do |hit|
	  result_hash = Hash.new
	  result_hash[:id] = (hit['id'].sub(/^club_message-(\d+)/, '\1').to_i)
	  result_hash[:club_id] = hit['club_message_club_id'].to_i
	  results.push(result_hash)
      end
      rescue Errno::ECONNREFUSED => error
	  flash['solr_down'] = true
      end

      if results.size > 0
        @club_messages = Array.new
	accessible_clubs = @user.clubs_active.map!{|club| club.id}.uniq
        results.each do |hash|
	  if accessible_clubs.include?(hash[:club_id])
	    @club_messages.push(ClubMessage.find_by_id(hash[:id]))
	  end
	end

	@club_messages = nil if @club_messages.empty?
      end
    end
  end

  def mail_message
    @query = params[:query]

    if @query and not @query.empty?
      query = '(' + @query + ') AND type:mail_message'
      query += " AND (mail_message_recipient_id:#{@user.id}"
      query += " OR mail_message_recipient_id:#{@user.id})"
      results = Array.new

      begin
        solr_result = SOLR.request('/select', :q => query)
        solr_result['response']['docs'].each do |hit|
	  results.push(hit['id'].sub(/^mail_message-(\d+)/, '\1').to_i)
      end
      rescue Errno::ECONNREFUSED => error
	  flash['solr_down'] = true
      end

      if results.size > 0
        mm = MailMessagesWrapper::MailMessagesWrapper.new(results)
        @mail_messages = mm.messages
      end
    end
  end
end
