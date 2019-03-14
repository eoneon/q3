class ItemGroup < ApplicationRecord
  belongs_to :origin, polymorphic: true
  belongs_to :target, polymorphic: true

  before_create :set_sort

  def set_sort
    self.sort = origin.grouped_subklass(target_type).count == 0 ? 1 : origin.grouped_subklass(target_type).count + 1
  end

  def self.model_list(*model_names)
    subklasses = []
    model_names.each do |model_name|
      subklasses << Dir.glob("#{Rails.root}/app/models/#{model_name}/*.rb").map{|x| x.split("/").last.split(".").first}
    end
    subklasses.flatten
  end
end
