require 'active_support/concern'

module MediumType
  extend ActiveSupport::Concern

  class_methods do

    def types
      %w[primary secondary tertiary category component category]
    end

    def primary
      %w[painting drawing mixed-media print sericel sculpture hand-blown hand-made]
    end

    def secondary
      %w[embellished hand-pulled sculpture-type]
    end

    def tertiary
      %w[leafing remarque]
    end

    def component
      %w[diptych triptych quadriptych set]
    end

    def category
      %w[original one-of-a-kind production limited-edition single-edition open-edition]
    end

    def material
      [%w[painting drawing mixed-media print].prepend('standard'), %w[photography], %w[sericel], %w[hand-blown], %w[hand-made], %w[sculpture]]
    end

    def medium_group
      primary | secondary | category
    end

    def medium_set
     [['original', 'painting'],
     ['original', 'drawing'],
     ['original', 'production', 'drawing'],
     ['original', 'production', 'sericel'],
     ['original', 'mixed-media'],
     ['one-of-a-kind', 'mixed-media'],
     ['embellished', 'one-of-a-kind', 'mixed-media'],
     ['single-edition', 'one-of-a-kind', 'mixed-media'],
     ['embellished', 'single-edition', 'one-of-a-kind', 'mixed-media'],
     ['one-of-a-kind', 'hand-pulled', 'print'],
     ['embellished', 'one-of-a-kind', 'hand-pulled', 'print'],
     ['single-edition', 'one-of-a-kind', 'hand-pulled', 'print'],
     ['embellished', 'single-edition', 'one-of-a-kind', 'hand-pulled', 'print'],
     ['print'],
     ['embellished', 'print'],
     ['single-edition', 'print'],
     ['hand-pulled', 'print'],
     ['open-edition', 'print'],
     ['photography'],
     ['limited-edition', 'print'],
     ['embellished', 'limited-edition', 'print'],
     ['limited-edition', 'hand-pulled', 'print'],
     ['single-edition', 'hand-pulled', 'print'],
     ['limited-edition', 'photography'],
     ['animation', 'sericel'],
     ['limited-edition', 'sericel'],
     ['hand-blown', 'sculpture-type'],
     ['hand-made', 'sculpture-type'],
     ['sculpture', 'sculpture-type'],
     ['embellished', 'sculpture', 'sculpture-type'],
     ['limited-edition', 'sculpture', 'sculpture-type'],
     ['embellished', 'limited-edition', 'sculpture', 'sculpture-type']]
    end
  end
end
