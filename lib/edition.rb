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
end
