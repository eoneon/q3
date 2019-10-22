class Element < ApplicationRecord
  #include Products
  include ObjBuild

  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :elements, through: :item_groups, source: :target, source_type: "Element"

  validates :name, presence: true

  scope :primary_media, -> {where("tags @> ?", ("primary => true"))}
  scope :products, -> {where(kind: "product")}
  scope :product_elements, -> {where.not(kind: "product")}
  scope :option_group, -> {where(kind: "option-group")}


  ProductElement.product_elements.map{|konstant| konstant.to_s.underscore}.each do |scope_name|
    scope :"#{scope_name}", -> {where(kind: scope_name)}
  end

  Product.boolean_tag_options.each do |scope_name|
    scope :"#{to_snake(scope_name)}", -> {products.where("tags ? :key", key: scope_name)}
    scope :"not_#{to_snake(scope_name)}", -> {products.where.not("tags ? :key", key: scope_name)}
  end

  scope :one_of_a_kind_mixed_media, -> {not_single_edition.one_of_a_kind.mixed_medium}
  scope :single_edition_one_of_a_kind_mixed_media, -> {single_edition.one_of_a_kind.mixed_medium}
  scope :print_media, -> {print.or(sericel).or(photography)}
  scope :not_original_media, -> {not_original.merge(not_one_of_a_kind)}
  scope :not_edition_media, -> {not_limited_edition.merge(not_single_edition).merge(not_open_edition)}
  scope :only_prints, -> {not_original_media.not_edition_media.print}
  scope :limited_edition_print_media, -> {limited_edition.print_media}
  scope :limited_edition_prints, -> {limited_edition.print}
  scope :limited_edition_sculptures, -> {not_hand_blown.merge(not_hand_made).sculpture.limited_edition}
  scope :standard_sculptures, -> {not_hand_blown.merge(not_hand_made).merge(not_limited_edition).sculpture}

  def self.by_kind(kind)
    self.where(kind: kind)
  end

  def self.by_option_group(option_type)
    self.where(kind: 'option-group').where("tags @> ?", ("option_type => #{option_type}"))
  end

  def self.element_search(kind)
    self.public_send(kind)
  end

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
