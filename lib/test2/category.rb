module Category
  extend Dimension

  def self.option_group
    self.constants.map {|konstant| konstant}
  end

  def option_sets
    self.constants.map {|klass| [scope_context(self, klass).name, scope_context(self, klass).option_set.map {|set| [set.to_s, EditionType.public_send(set)]}]}
  end

  def format_name
    if kind == 'material' && (Material::Sericel.options).append(Material::SculptureMaterial.options).flatten.exclude?(name)
      "on #{name}"
    elsif ['print medium', 'basic print', 'standard print', 'mixed medium'].exclude?(name)
      name
    end
  end

  def decamelize(camel_word, *n)
    word_count = n.empty? ? 0 : n.first
    name_set = camel_word.to_s.underscore.split('_')
    name_set.count >= word_count ? name_set.join('-') : name_set.join(' ')
  end

  def kind
    decamelize(self.to_s.split('::')[-2])
  end

  def name
    decamelize(self.to_s.split('::').last, 3)
  end

  def search_text
    [category, name].join(' ').pluralize
  end

  def scope_context(*objs)
    set=[]
    objs.each do |obj|
      if obj.to_s.index('::')
        obj.to_s.split('::').map {|konstant| set << konstant}
      else
        set << format_constant(obj)
      end
    end
    set.join('::').constantize
  end

  def format_constant(konstant)
    konstant.to_s.split(' ').map {|word| word.underscore.split('_').map {|split_word| split_word.capitalize}}.flatten.join('')
  end

  class Original
    extend Category

    def self.category
      decamelize(self.superclass.to_s.split('::').last)
    end

    def self.dimension
      Dimension::TwoDimension
    end

    def self.name_order
      [:category, :option, :medium, :material]
    end

    def self.medium
      self.subclasses
    end
  end

  class OneOfAKind
    extend Category

    def self.category
      decamelize(self.superclass.to_s.split('::').last)
    end

    def self.dimension
      Dimension::TwoDimension
    end

    def self.name_order
      [:category, :option, :material]
    end
  end

  class PrintMedium
    extend Category

    def self.category
      decamelize(self.superclass.to_s.split('::').last)
    end

    def self.dimension
      Dimension::TwoDimension
    end

    def self.name_order
      [:option, :material]
    end

    def self.search_text
      name.pluralize
    end

  end

  class Sculpture
    extend Category

    def self.category
      decamelize(self.superclass.to_s.split('::').last)
    end

    def self.dimension
      Dimension::SculptureDimension
    end

    def self.name_order
      [:option, :material, :sculpture_type, :category]
    end

    def self.search_text
      [name.split('-').join(' '), category].join(' ').pluralize
    end

    # def self.sculpture_type
    #   ['sculpture', 'vase', 'flat vase', 'bowl', 'jar', 'pumpkin', 'heart']
    # end
  end
end
