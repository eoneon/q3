module Edition
  class BooleanTag
    def limited
      %w[numbered-xy numbered from-an-edition]
    end

    def single
      %w[single-edition]
    end

    def open
      %w[open-edition]
    end
  end

  class OptionGroupSet
    def limited_edition
      [
        %w[numbered-xy], %w[numbered], %w[from-an-edition]
      ]
    end
  end

  class OptionGroupMatch
    def limited_edition
      h ={kind: 'medium', name: 'limited-edition'}
    end
  end
end
