module ProductOption
  class LimitedEdition
    [:limited_edition]
  end

  class Embellished
    [:embellished]
  end

  class SingleEdition
    [:single_edition]
  end

  class EmbellishedLimitedEdition
    [:embellished, :limited_edition]
  end

  class EmbellishedSingleEdition
    [:embellished, :single_edition]
  end
end
