class Artist < ApplicationRecord
  has_many :items, dependent: :destroy

  def self.by_last_name
    Artist.all.order("properties -> 'lastname'")
  end

  def name_arr
    [properties["first_name"], properties["last_name"]].compact
  end

  def first_last
    name_arr.join(" ")
  end

  def last_first
    name_arr.reverse.join(", ")
  end

  def format_years
    "(#{properties["years"]})" if properties["years"]
  end

  def display_name
    [first_last, format_years].compact.join(" ")
  end
end
