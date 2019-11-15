class Element < ApplicationRecord
  include ObjBuild

  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :elements, through: :item_groups, source: :target, source_type: "Element"

  validates :name, presence: true

  scope :products, -> {where(kind: "product")}
  scope :option_group_sets, -> {where("tags @> ?", ("option_kind => option-group-set"))}
  scope :option_groups, -> {where(kind: "option-group")}

  scope :flat_media, -> {where(kind: "medium", name: Product.flat_media)}
  scope :sculpture_media, -> {where(kind: "medium", name: Product.sculpture_media)}

  scope :all_material, -> {where(kind: "material", name: Material.all_material)}
  scope :flat_dimension_material, -> {where(kind: "material", name: Material.flat_dimension_material.reject {|material| material == 'canvas'})}
  scope :canvas_dimension_material, -> {where(kind: "material", name: 'canvas')}
  scope :standard_sculpture, -> {where(kind: "material", name: Material.standard_sculpture)}

  Product.scopes.each do |set|
    scope :"#{set[0]}", -> {products.order("tags -> 'embellished'").where("tags @> ? AND tags @> ?", ("category => #{set[1]}"), ("medium => #{set[2]}"))}
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

# Product.boolean_tag_options.each do |scope_name|
#   scope :"#{to_snake(scope_name)}", -> {products.where("tags ? :key", key: scope_name)}
#   scope :"not_#{to_snake(scope_name)}", -> {products.where.not("tags ? :key", key: scope_name)}
# end

# scope :one_of_a_kind_mixed_media, -> {not_single_edition.one_of_a_kind.mixed_medium}
# scope :single_edition_one_of_a_kind_mixed_media, -> {single_edition.one_of_a_kind.mixed_medium}
#
# scope :print_media, -> {standard_print.or(hand_pulled_print).or(sericel).or(photography)}
# scope :not_original_media, -> {not_original.merge(not_one_of_a_kind)}
# scope :not_edition_media, -> {not_limited_edition.merge(not_single_edition).merge(not_open_edition)}
#
# scope :only_prints, -> {not_original_media.not_edition_media.standard_print}
# scope :limited_edition_print_media, -> {limited_edition.print_media}
#
# scope :limited_edition_prints, -> {limited_edition.standard_print}
# scope :limited_edition_sculptures, -> {not_hand_blown.merge(not_hand_made).sculpture.limited_edition}
# scope :standard_sculptures, -> {not_hand_blown.merge(not_hand_made).merge(not_limited_edition).sculpture}
