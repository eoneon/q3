class Element < ApplicationRecord
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :elements, through: :item_groups, source: :target, source_type: "Element"

  validates :name, presence: true

  #scope :media, -> {where("tags @> ?", ("type => medium"))}

  def self.scoped_elements(kind)
    self.where(kind: kind)
  end

  def self.readable_objs(set)
    a =[]
    set.each do |obj|
      name = "<#{obj.kind.upcase}: #{obj.name}, tags:"
      #tags = obj.tags.each {|k,v| "#{k} => #{v}"}.join(', ')
      #tags = obj.tags.to_a {|set| "#{set[0]} => #{set[1]}"}.flatten.join(', ')
      tags = obj.tags.to_a {|set| set.join(' => ')}.flatten.join(', ')
      a << [name, "#{tags}>"].join(' ')
    end
    a
  end
end
