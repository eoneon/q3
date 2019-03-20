class ItemGroup < ApplicationRecord
  belongs_to :origin, polymorphic: true
  belongs_to :target, polymorphic: true

  before_create :set_sort

  def set_sort
    self.sort = origin.grouped_subklass(target_type).count == 0 ? 1 : origin.grouped_subklass(target_type).count + 1
  end

  def self.subklass_list(*model_dir)
    self.dir_list(*model_dir).map {|dir_name| dir_name.classify}
  end

  def self.dir_list(*model_dir)
    dir_names = []
    model_dir.each do |dir_name|
      dir_names << Dir.glob("#{Rails.root}/app/models/#{dir_name}/*.rb").map{|x| x.split("/").last.split(".").first}
    end
    dir_names.flatten
  end
end
