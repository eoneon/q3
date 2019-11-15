module OptionGroupAssoc
  extend BuildSet

  def self.populate
    self.constants.each do |klass|
      to_scoped_constant(self, klass).set.each do |opt_grp_arr|
        opt_grp = OptionGroupSet.create_opt(klass: to_snake(klass).split('_').last, name: opt_grp_arr.last, idx: 1)
        opt_grp_arr.first.map {|obj| assoc_unless_included(origin: obj, target: opt_grp)}
      end
    end
  end

  def self.kind_and_option_type_pairs
    self.constants.map {|klass| [to_snake(klass).split('_').first, to_snake(klass).split('_').last]}
  end

  #pattern: element << option-group
  #embellishment << embellished-option-groups
  class EmbellishmentEmbellished
    def self.embellishment
      Element.where(kind: 'embellishment', name: 'embellished')
    end

    def self.set
      [
        [embellishment, OptionGroupSet::Embellished::OptionGroup.set[0]]
      ]
    end
  end

  #category << edition-option-groups
  class CategoryEdition
    def self.category
      Element.where(kind: 'category', name: 'limited edition')
    end

    def self.set
      [
        [category, OptionGroupSet::Edition::OptionGroup.set[0]],
        [category, OptionGroupSet::Edition::OptionGroup.set[1]],
        [category, OptionGroupSet::Edition::OptionGroup.set[2]]
      ]
    end
  end

  #medium << dimension-option-groups
  class MediumDimension
    def self.set
      [
        [Element.flat_media, OptionGroupSet::Dimension::OptionGroup.set[0]],
        [Element.sculpture_media, OptionGroupSet::Dimension::OptionGroup.set[1]]
      ]
    end
  end

  #material << mounting-option-groups
  class MaterialMounting
    def self.set
      [
        [Element.flat_dimension_material, OptionGroupSet::Mounting::OptionGroup.set[0]],
        [Element.standard_sculpture, OptionGroupSet::Mounting::OptionGroup.set[1]],
        [Element.canvas_dimension_material, OptionGroupSet::Mounting::OptionGroup.set[2]]
      ]
    end
  end

  #mounting << dimension-option-groups
  class MountingDimension
    def self.set
      [
        [[Element.find_by(name: OptionGroupSet::Mounting::OptionGroup.set[0])], OptionGroupSet::Dimension::OptionGroup.set[0]],
        [[Element.find_by(name: OptionGroupSet::Mounting::OptionGroup.set[1])], OptionGroupSet::Dimension::OptionGroup.set[1]]
      ]
    end
  end

  #medium << leafing-option-groups
  class MediumLeafing
    def self.set
      [
        [Element.where(name: ['basic print', 'standard print']), 'leafing']
      ]
    end
  end

  #medium << remarque-option-groups
  class MediumRemarque
    def self.set
      [
        [Element.where(name: ['basic print', 'standard print']), 'remarque']
      ]
    end
  end

  #material << certificate-option-groups
  class MaterialCertificate
    def self.set
      [
        [Element.all_material, OptionGroupSet::Certificate::OptionGroup.set[0]],
        [Element.all_material, OptionGroupSet::Certificate::OptionGroup.set[1]]
      ]
    end
  end

  #material << material-option-groups
  class MaterialMaterial
    def self.set
      set =[]
      OptionGroupSet::Material::OptionGroup.set.each do |option_group_name|
        set << [Element.where(kind: 'material', name: option_group_name), option_group_name]
      end
      set
    end
  end
end
