module Menu
  class Menu
    attr_reader :sections

    def initialize
      @sections = []
    end

    def clear
      @sections = []
    end

    def add_section section
      @sections << section
    end

    def create_section options = {}
      options[:_menu] = self
      section = Section.new(options)
      self.add_section(section)
      return section
    end

    def active_section options
      @sections.each do |section|
        return section if section.has_action?(options)
      end
    end

    def get_section_by_name name
      @sections.each do |section|
        return section if section.name == name
      end
    end
  end
  class Section
    attr_accessor :name, :options
    attr_reader :actions, :menu

    def initialize options = {}
      @name = options.delete(:section_name)
      @menu = options.delete(:_menu)
      @options = options      
      @actions = []
      @map = []
    end

    def make_id options = {}
      "#{options[:controller]}/#{options[:action]}"
    end

    def register_action options = {}
      id = self.make_id(options)
      @map << id if not @map.include?(id)
    end

    def add_action action
      @actions << action
      self.register_action(action.options)
    end

    def create_action options = {}
      options[:_section] = self
      action = Action.new( options )
      self.add_action(action)
      return action
    end

    def has_action? options = {}
      return @map.include?(self.make_id(options))
    end
  end
  class Action
    attr_accessor :name, :options
    attr_reader :section

    def initialize options = {}
      @name = options.delete(:action_name)
      @section = options.delete(:_section)
      @options = options
      @map = []
      self.register_alias(options)
    end

    def make_id options = {}
      "#{options[:controller]}/#{options[:action]}"
    end

    def register_alias options = {}
      @map << self.make_id(options)
      @section.register_action(options)
    end

    def is_active? options = {}
      return @map.include?(self.make_id(options))
    end
  end
end