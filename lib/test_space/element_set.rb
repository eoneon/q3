module ElementSet

  # class Medium
  #   def self.media_sets
  #     [
  #       %w[original painting],
  #       %w[original drawing],
  #       %w[original production drawing],
  #       %w[original production sericel],
  #       %w[original mixed-media],
  #       %w[one-of-a-kind mixed-media],
  #       %w[embellished one-of-a-kind mixed-media],
  #       %w[single-edition one-of-a-kind mixed-media],
  #       %w[embellished single-edition one-of-a-kind mixed-media],
  #       %w[one-of-a-kind hand-pulled print],
  #       %w[embellished one-of-a-kind hand-pulled print],
  #       %w[single-edition one-of-a-kind hand-pulled print],
  #       %w[embellished single-edition one-of-a-kind hand-pulled print],
  #       %w[print],
  #       %w[embellished print],
  #       %w[single-edition print],
  #       %w[hand-pulled print],
  #       %w[open-edition print],
  #       %w[photography],
  #       %w[limited-edition print],
  #       %w[embellished limited-edition print],
  #       %w[limited-edition hand-pulled print],
  #       %w[embellished limited-edition hand-pulled print],
  #       %w[single-edition hand-pulled print],
  #       %w[limited-edition photography],
  #       %w[sericel],
  #       %w[limited-edition sericel],
  #       %w[hand-blown sculpture],
  #       %w[hand-made sculpture],
  #       %w[sculpture],
  #       %w[embellished sculpture],
  #       %w[limited-edition sculpture],
  #       %w[embellished limited-edition sculpture]
  #     ]
  #   end
  # end

  class Medium
    def self.sub_media
      [
        %w[leafing],
        %w[remarque],
        %w[leafing remarque]
      ]
    end
  end

  class Edition
    def self.limited_edition
      [
        %w[numbered-xy],
        %w[numbered],
        %w[from-an-edition]
      ]
    end
  end

  class Signature
    def self.flat_signature
      [
        %w[artist],
        %w[artist artist],
        %w[artist relative],
        %w[artist celebrity],
        %w[celebrity],
        %w[relative]
      ]
    end

    def self.sculpture_signature
      [
        %w[artist-3d]
      ]
    end
  end

  class Certificate
    def self.standard_certificate
      [
        %w[standard-certificate],
        %w[publisher-certificate]
      ]
    end

    def self.animation_certificate
      [
        %w[animation-seal sports-seal animation-certificate],
        %w[animation-seal animation-certificate],
        %w[sports-seal animation-certificate],
        %w[sports-seal animation-seal],
        %w[animation-certificate],
        %w[sports-seal]
      ]
    end
  end
end
