module Komunity
  def self.create_menu
    menu = Menu::Menu.new

    section = menu.create_section(:section_name => 'Profil', :controller => :profile, :action => :report)
    section.create_action(:action_name => 'Můj profil', :controller => :profile, :action => :index)
    section.create_action(:action_name => 'Přehled', :controller => :profile, :action => :report)
    action = section.create_action(:action_name => 'Přátelé', :controller => :profile, :action => :friends)
    action.register_alias :controller => :friends, :action => :search

    section = menu.create_section(:section_name => 'Zprávy', :controller => :messages, :action => :index)
    section.create_action(:action_name => 'Napsat', :controller => :messages, :action => :compose)
    section.create_action(:action_name => 'Doručené', :controller => :messages, :action => :index)

    section = menu.create_section(:section_name => 'Kluby', :controller => :clubs, :action => :index)
    action = section.create_action(:action_name => 'Přehled', :controller => :clubs, :action => :index)
    action.register_alias :controller => :clubs, :action => :create
    section.create_action(:action_name => 'Procházet', :controller => :clubs, :action => :browser)

    section = menu.create_section(:section_name => 'Úschovna', :controller => :storage, :action => :browser)
    #section.create_action(:name => 'Přehled', :controller => :storage, :action => :index)
    section.create_action(:action_name => 'Prohlížeč', :controller => :storage, :action => :browser)

    section = menu.create_section(:section_name => 'Noviny', :controller => :news, :action => :index)
    section.create_action(:action_name => 'Přehled', :controller => :news, :action => :index)
    section.create_action(:action_name => 'Přidat zdroj', :controller => :news, :action => :add)

    section = menu.create_section(:section_name => 'Vyhledávání', :controller => :search, :action => :club_message)
    section.create_action(:action_name => 'Hledat příspěvek', :controller => :search, :action => :club_message)
    section.create_action(:action_name => 'Hledat zprávu', :controller => :search, :action => :mail_message)

    return menu
  end
end
