require 'active_support/concern'

module ScopeBuild
  extend ActiveSupport::Concern

  class_methods do
    def option_types
      %w[origin-type origin-class option-group option-key assoc-key option-value]
    end

    # attr methods ###############################################################
    
    def element_attrs
      h = {kind: element_kind, name: element_name, tags: element_tags}
    end

    def option_value_attrs(name)
      option_value_attrs = element_attrs
      option_value_attrs[:name] = name
      option_value_attrs
    end

    def element_kind
      [element_type, option_type].join('-')
    end

    def element_name
      name = decamelize(slice_class(-1))
      if name == 'option group'
        [decamelize(origin), 'option'].join(' ')
      else
        name
      end
    end

    def element_tags
      h= {element_type: element_type, option_type: option_type}
      #h[:product_name] = product_name(element_name) if slice_class(-1).to_s == 'OptionGroup'
      h
    end

    def assoc_key_attrs(assoc)
      if decamelize(slice_class(-1),'_') == 'assoc_group'
        h = {kind: [assoc.to_s, 'assoc-key'].join('-'), name: [decamelize(origin), assoc.to_s, 'assoc-option'].join(' '), tags: {origin_type: element_type, target_type: assoc.to_s, option_type: option_type}}
      end
    end

    # def self.option_value_attrs(name)
    #   if decamelize(slice_class(-1),'_') == 'assoc_group'
    #     h = {kind: [assoc.to_s, 'assoc-key'].join('-'), name: [decamelize(origin), assoc.to_s, 'assoc-option'].join(' '), tags: {origin_type: element_type, target_type: assoc.to_s, option_type: option_type}}
    #   end
    # end

    def element_type
      if ['OptionValue', 'AssocValue'].include?(slice_class(-1))
        current_file
      else
        current_dir
      end
    end

    def option_values
      scope_context(current_dir, origin, 'option_value')
    end

    def assoc_values
      scope_context(current_dir, origin, 'assoc_value')
    end

    def option_type
      if origin_types.include?(current_file) && slice_class(-1).to_s != 'OptionValue' && slice_class(-1).to_s != 'AssocValue'
        option_types[0]
      elsif origin_classes.include?(decamelize(klass_name, '_'))
        option_types[1]
      elsif constants.include?(:OptionGroup)
        option_types[2]
      elsif slice_class(-1).to_s == 'OptionGroup'
        option_types[3]
      elsif slice_class(-1).to_s == 'AssocGroup'
        option_types[4]
      elsif slice_class(-1).to_s == 'OptionValue'
        option_types[5]
      end
    end
  end

end
