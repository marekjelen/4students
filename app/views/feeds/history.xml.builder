xml.instruct!

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do
    xml.title "#{@user.display}"
    xml.language 'cs'
    xml.link url_for(:only_path => false, :controller => 'public')
    xml.description "Výpis událostí týkájících se uživatele #{@user.display}."

    @histories.each do |history|
      xml.item do
        xml.title history.user.display
        xml.link url_for(:only_path => false, :controller => :profile, :action => :report)
        if history.options
          xml.description t("history.feeds.messages.#{history.key}", Marshal.load(history.options))
        else
          xml.description t("history.feeds.messages.#{history.key}")
        end
        xml.pudDate history.created_at
        xml.guid history.id, :isPermaLink => false
      end
    end
  end
end