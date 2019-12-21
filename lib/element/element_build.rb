class ElementBuild

  def self.option_group
    self.constants.map {|konstant| konstant}
  end

  # def option_sets
  #   option_group.map {|klass| [scope_context(self, klass).name, scope_context(self, klass).option_set.map {|set| [set.to_s, EditionType.public_send(set)]}]}
  # end

  ############################################################################## utility methods

  def self.decamelize(camel_word, *n)
    word_count = n.empty? ? 0 : n.first
    name_set = camel_word.to_s.underscore.split('_')
    name_set.count >= word_count ? name_set.join('-') : name_set.join(' ')
  end

  ############################################################################## attr methods

  def self.kind
    decamelize(self.to_s.split('::')[-2])
  end

  def self.name
    decamelize(self.to_s.split('::').last, 3)
  end

  def self.category
    decamelize(self.superclass.to_s.split('::').last, 3)
  end

  # def self.tags(option_kind)
  #   h = {"option_kind" => option_kind, "element_kind" => kind}
  # end

  def self.hello
    'world'
  end

  # def self.format_name
  #   if kind == 'material' && (Material::Sericel.options).append(Material::SculptureMaterial.options).flatten.exclude?(name)
  #     "on #{name}"
  #   elsif ['print medium', 'basic print', 'standard print', 'mixed medium'].exclude?(name)
  #     name
  #   end
  # end

  ############################################################################## scope methods

  def self.scope_context(*objs)
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

  def self.format_constant(konstant)
    konstant.to_s.split(' ').map {|word| word.underscore.split('_').map {|split_word| split_word.capitalize}}.flatten.join('')
  end

  ############################################################################## search methods

  def self.search_text
    [category, name].join(' ').pluralize
  end

  ############################################################################## utility methods

  def self.decamelize(camel_word, *n)
    word_count = n.empty? ? 0 : n.first
    name_set = camel_word.to_s.underscore.split('_')
    name_set.count >= word_count ? name_set.join('-') : name_set.join(' ')
  end

  ##############################################################################
end
