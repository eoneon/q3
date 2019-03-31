class ItemValue < ApplicationRecord
  include Importable
  include Sti

  # after_initialize do
  #   self.type = self.class.name
  # end
end
