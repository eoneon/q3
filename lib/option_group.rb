module OptionGroup
  extend BuildSet
  #OptionGroup.populate

  def self.populate
    [[Category,:dimension], [Material,:mounting], [Mounting,:dimension]].each do |assoc_set|
      mojule, method_sym = assoc_set.first, assoc_set.last
      mojule.option_group.each do |konstant|
        origin = find_or_create_by(attr_values(to_scoped_constant(mojule, konstant)))
        target = find_or_create_by(attr_values(to_scoped_constant(mojule, konstant).public_send(method_sym)))
        assoc_unless_included(origin: origin, target: target)
      end
    end
  end
end
