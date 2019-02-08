#require 'active_support/concern'
module Importable
  extend ActiveSupport::Concern

  class_methods do
    def to_csv(fields = column_names, options = {})
      CSV.generate(options) do |csv|
        csv << fields
        all.each do |record|
          csv << record.attributes.values_at(*fields)
        end
      end
    end

    def import(file)
      spreadsheet = Roo::Spreadsheet.open(file.path)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        record = find_by(id: row["id"]) || new
        record.attributes = row.to_hash
        record.save!
      end
    end
  end
end
