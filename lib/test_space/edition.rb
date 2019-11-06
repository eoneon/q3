module Edition
  extend BuildSet
  extend ProductBuild

  def self.populate
  end

  def self.edition_type
    %w[AP EA CP GP PP IP HC TC]
  end

  class NumberedXy
    def edition_element
      [nil, Edition.edition_type]
    end
  end

  class NumberedQty
    def edition_element
      [nil, Edition.edition_type]
    end
  end

  class FromAnEdition
    def edition_element
      [Edition.edition_type]
    end
  end

  # class OptionGroupSet
  #   def limited_edition
  #     [
  #       %w[numbered-xy], %w[numbered], %w[from-an-edition]
  #     ]
  #   end
  # end
  #
  # class OptionGroupMatch
  #   def limited_edition
  #     h ={kind: 'medium', name: 'limited-edition'}
  #   end
  # end
  # def edition_kind
  #   %w[numbered-xy numbered from-an-edition]
  # end
end
