class Artist < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_types, dependent: :destroy

  def self.ordered_artists
    Artist.order("properties -> 'last_name'")
  end

  def name_arr
    [properties["first_name"], properties["last_name"]].reject {|i| i.blank?}
  end

  def first_last
    name_arr.join(" ")
  end

  def last_first
    name_arr.reverse.join(", ")
  end

  def format_years
    "(#{properties["years"]})" unless properties["years"].blank?
  end

  def display_name
    [first_last, format_years].reject {|i| i.blank?}.join(" ")
  end
end
