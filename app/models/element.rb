class Element < ApplicationRecord
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :elements, through: :item_groups, source: :target, source_type: "Element"
  has_many :products, through: :item_groups, source: :target, source_type: "Product"

  validates :name, presence: true

  scope :primary_media, -> {where("tags @> ?", ("primary => true"))}

  def self.scoped_elements(kind)
    self.where(kind: kind)
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
