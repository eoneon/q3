class Element < ApplicationRecord
  include ObjBuild

  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :elements, through: :item_groups, source: :target, source_type: "Element"

  validates :name, presence: true

  scope :products, -> {where(kind: "product")}

  Product.search.each do |h|
    scope h[:scope_name], -> {products.where("tags @> ? AND tags @> ?", ("category => #{h[:category]}"), ("medium => #{h[:medium]}"))}
  end

  def self.by_kind(kind)
    self.where(kind: kind)
  end

  def self.search(scope)
    self.public_send(scope)
  end

  ################################

  def product_options(kind, option_type)
    product_option_group(kind, option_type).first.elements.where("tags @> ? AND tags @> ?", ("option_type => #{option_type}"), ("option_kind => option"))
  end

  def product_option_group(kind, option_type)
    nested_element_kind(kind).elements.where("tags @> ? AND tags @> ?", ("option_type => #{option_type}"), ("option_kind => option-group")) if nested_element_kind(kind)
  end

  def nested_element_kind(kind)
    set = elements.where(kind: kind)
    set.first if set.any?
  end

  def option_group_elements
    if kind == 'product'
      elements.where(kind: ProductType.option_group_types).map {|option_group| option_group.elements.where("tags ? :key", key: "option_type")}.flatten
    end
  end

  def scoped_option_group(option_type)
    option_group_elements.keep_if {|obj| obj.tags["option_type"] == option_type}
  end

  def option_type_collection
    ProductType.option_group_types.map {|option_type| scoped_option_group(option_type) if scoped_option_group(option_type).any?}.compact
  end

  ################################ Element.readable_objs(set)

  def self.readable_objs(set)
    a =[]
    set.each do |obj|
      if obj.is_a? Array
        a << obj.map{|element| element.name}
      else
        name = "<#{obj.kind.upcase}: #{obj.name}, tags:"
        tags = obj.tags.to_a {|set| set.join(' => ')}.flatten.join(', ')
        a << [name, "#{tags}>"].join(' ')
      end
    end
    a
  end
end
