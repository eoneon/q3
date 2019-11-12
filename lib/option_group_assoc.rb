module OptionGroupAssoc
  extend BuildSet

  def self.populate
    self.constants.each do |klass|
      klass.set.each do |opt_grp_arr|
        kind = to_snake(klass).split('_').first
        opt_grp = find_or_create_by(kind: 'option-group', name: opt_grp_arr.last)
        assoc_set.map {|opt_name| find_or_create_by(kind: kind, name: opt_name)}.map {|option| assoc_unless_included(origin: option, target: opt_grp)}
      end
    end
  end

  #medium << dimension
  class MediumDimension
    def self.set
      [
        [FlatProduct.medium_elements, OptionGroupSet::Dimension::OptionGroup.set[0]],
        [SculptureProduct.medium_elements, OptionGroupSet::Dimension::OptionGroup.set[1]]
      ]
    end
  end

  #material << mounting
  class MaterialMounting
    def self.set
      [
        [Material.flat_dimension_material.reject {|material| material == 'canvas'}, OptionGroupSet::Mounting::OptionGroup.set[0]],
        [Material.standard_sculpture, OptionGroupSet::Mounting::OptionGroup.set[1]],
        [%w[canvas], OptionGroupSet::Mounting::OptionGroup.set[2]]
      ]
    end
  end

  #mounting << dimension
  class MountingDimension
    def self.set
      [
        [OptionGroupSet::Mounting::OptionGroup.set[0]], OptionGroupSet::Dimension::OptionGroup.set[0]],
        [OptionGroupSet::Mounting::OptionGroup.set[1]], OptionGroupSet::Dimension::OptionGroup.set[1]],
        [OptionGroupSet::Mounting::OptionGroup.set[2]], OptionGroupSet::Dimension::OptionGroup.set[2]]
      ]
    end
  end

  #medium << leafing
  class MediumLeafing
    def self.set
      [
        ['basic print', 'standard print'], ['leafing-option-group-set']
      ]
    end
  end

  #medium << remarque
  class MediumRemarque
    def self.set
      [
        ['basic print', 'standard print'], ['remarque-option-group-set']
      ]
    end
  end

end
