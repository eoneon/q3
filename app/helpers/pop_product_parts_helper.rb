module PopProductPartsHelper
  ##################################################################  tags_hash methods
  def sti_opts
    ['medium', 'material', 'edition', 'signature', 'dimension', 'mounting', 'certificate']
  end

  def tags_hash
    h = {medium_tags: medium_tags, material_tags: material_tags, edition_tags: edition_tags, signature_tags: signature_tags, dimension_tags: dimension_tags, mounting_tags: mounting_tags, certificate_tags: certificate_tags, product_kind_tags: product_kind_tags}
  end

  ############################## key == tag name

  def medium_tags
    h = {medium_type: scoped_medium_types}
  end

  def material_tags
    h = {dimension_type: scoped_material_dimension_types, medium_assoc: scoped_material_medium_assoc}
  end

  def edition_tags
    h = {edition_type: scoped_edition_types}
  end

  def signature_tags
    h = {signature_type: scoped_signature_types}
  end

  def dimension_tags
    h = {two_d: two_dimension_types, three_d: three_dimension_types}
  end

  def mounting_tags
    h = {two_d: two_dimension_mounting_types, three_d: three_dimension_mounting_types}
  end

  def certificate_tags
    h = {certificate_type: scoped_certificate_types}
  end

  def product_kind_tags
    #h = {material_assoc: scoped_medium_material_assoc}
    h = {material_assoc: scoped_medium_material_assoc, signature_type: product_kind_signature_types, certificate_type: product_kind_certificate_types}
  end

  ############################## 'has_one' tags: mutually exclusive of each other

  def scoped_medium_types
    [primary_media.prepend('primary'), secondary_media.prepend('secondary'), component_media.prepend('component')]
  end

  def scoped_medium_material_assoc
    [flat_medium_materials.prepend('flat'), drawing_medium_materials, photo_medium_materials, sericel_medium_materials, sculpture_medium_materials, hand_blown_medium_materials, hand_made_medium_materials]
  end

  def scoped_material_medium_assoc
    [flat_materials.prepend('flat'), photography_materials.prepend('photography'), sericel_materials, sculpture_materials.prepend('sculpture'), hand_blown_materials.prepend('hand-blown'), hand_made_medium_materials.prepend('hand-made')]
  end

  def scoped_material_dimension_types
    [two_d_materials.prepend('two-d'), three_d_materials.prepend('three-d')]
  end

  def scoped_edition_types
    [limited_edition.prepend('limited-edition'), open_edition, single_edition]
  end

  def scoped_signature_types
    [two_dimension_signatures.prepend('two-d'), three_dimension_signatures.prepend('three-d')]
  end

  def scoped_certificate_types
    [standard_certificates.prepend('standard'), sericel_certificates.prepend('sericel')]
  end

  def product_kind_signature_types
    [['painting', 'drawing', 'mixed-media', 'print', 'photography', 'sericel'].prepend('two-d'), ['sculpture', 'hand-made', 'hand-blown'].prepend('three-d')]
  end

  def product_kind_certificate_types
    [['sericel'], ['painting', 'drawing', 'mixed-media', 'print', 'photography', 'sculpture', 'hand-made', 'hand-blown'].prepend('standard')]
  end

  ############################## 'has_many' tags: items may have more than one scoped tag

  def two_dimension_types
    [two_dimensions.prepend('true')]
  end

  def three_dimension_types
    [three_dimensions.prepend('true')]
  end

  def two_dimension_mounting_types
    [two_dimension_mountings.prepend('true')]
  end

  def three_dimension_mounting_types
    [three_dimension_mountings.prepend('true')]
  end

  ########################################################### medium name sets & conditions

  def medium_names
    primary_media | secondary_media | component_media
  end

  def primary_media
    ['original', 'painting', 'drawing', 'production', 'one-of-a-kind', 'mixed-media', 'limited-edition', 'embellished', 'single-edition', 'open-edition', 'print', 'hand-pulled', 'hand-made', 'hand-blown', 'photography', 'sculpture', 'sculpture-type', 'animation', 'sericel']
  end

  def secondary_media
    ['leafing', 'remarque']
  end

  def component_media
    ['diptych', 'triptych', 'quadriptych', 'set']
  end

  def flat_art
    ['original', 'one-of-a-kind', 'print']
  end

  def photo_art
    ['photography']
  end

  def sericel_art
    ['sericel']
  end

  def sculpture_art
    ['sculpture']
  end

  def hand_blown_art
    ['hand-blown']
  end

  def hand_made_art
    ['hand-made']
  end

  ########################################################### material name sets

  def material_names
    flat_materials | photography_materials | drawing_materials |sericel_materials | sculpture_materials | hand_blown_materials | hand_made_materials
  end

  def two_d_materials
    flat_materials | drawing_materials | photography_materials | sericel_materials
  end

  def three_d_materials
    sculpture_materials | hand_blown_materials | hand_made_materials
  end

  def flat_materials
    ['canvas', 'paper', 'board', 'metal']
  end

  def drawing_materials
    ['drawing-paper']
  end

  def photography_materials
    ['photography-paper']
  end

  def sericel_materials
    ['sericel', 'sericel with background']
  end

  def sculpture_materials
    ['metal', 'glass', 'mixed-media','ceramic']
  end

  def hand_blown_materials
    ['glass']
  end

  def hand_made_materials
    ['ceramic']
  end

  ######### product_kind medium materials

  def flat_medium_materials
    ['painting', 'mixed-media', 'print']
  end

  def drawing_medium_materials
    ['drawing']
  end

  def photo_medium_materials
   ['photograph']
  end

  def sericel_medium_materials
   ['sericel']
  end

  def sculpture_medium_materials
    ['sculpture']
  end

  def hand_blown_medium_materials
    ['hand-blown']
  end

  def hand_made_medium_materials
    ['hand-made']
  end

  ########################################################### edition name sets

  def edition_names
    limited_edition | open_edition | single_edition
  end

  def limited_edition
    ['numbered-xy', 'numbered', 'from-an-edition']
  end

  def open_edition
    ['open-edition']
  end

  def single_edition
    ['single-edition']
  end

  ########################################################### signature name sets

  def signature_names
    two_dimension_signatures.concat(three_dimension_signatures)
  end

  def two_dimension_signatures #signature_type: 'two-d'
    ['artist', 'relative', 'celebrity']
  end

  def three_dimension_signatures #signature_type: 'three-d'
    ['artist-3d']
  end

  def two_d_signature_set
    [['artist'],
    ['artist', 'artist'],
    ['artist', 'relative'],
    ['artist', 'celebrity'],
    ['celebrity'],
    ['relative']]
  end

  def three_d_signature_set
    [['artist-3d']]
  end

  ########################################################### dimension & mounting name sets

  def dimension_names
    two_dimensions | three_dimensions
  end

  def two_dimensions
    ['width', 'height']
  end

  def three_dimensions
    ['width', 'height', 'depth']
  end

  def mounting_names
    two_dimension_mountings | three_dimension_mountings
  end

  def two_dimension_mountings
    ['framed', 'bordered', 'matted', 'wall-mount']
  end

  def three_dimension_mountings
    ['case', 'base', 'wall-mount']
  end

  ########################################################### certificate name sets

  def certificate_names
    standard_certificate_names | sericel_certificate_names
  end

  def standard_certificate_names
    ['standard-certificate', 'publisher-certificate']
  end

  def sericel_certificate_names
    ['animation-seal', 'sports-seal', 'animation-certificate']
  end

  def standard_certificate_set
    [['standard-certificate'], ['publisher-certificate']]
  end

  def sericel_certificate_set
    [
      ['animation-seal', 'sports-seal', 'animation-certificate'],
      ['animation-seal', 'animation-certificate'],
      ['sports-seal', 'animation-certificate'],
      ['sports-seal', 'animation-seal'],
      ['animation-certificate'],
      ['sports-seal']
    ]
  end

  ########################################################### signature_and_certificate_option_groups

  def option_group_hash
    h={sti: :option_group, target_types: [:signature, :certificate]}
  end

  def two_d_standard
    h={name: 'two-d-signature standard-certificate', target_type_tags: ['two-d', 'standard']}.merge(two_d_standard_set)
  end

  def three_d_standard
    h={name: 'three-d-signature standard-certificate', target_type_tags: ['three-d', 'standard']}.merge(three_d_standard_set)
  end

  def two_d_sericel
    h={name: 'two-d-signature sericel-certificate', target_type_tags: ['two-d', 'sericel']}.merge(two_d_sericel_set)
  end

  ###########################################################

  def two_d_standard_set
    h={set: build_signature_and_certificate_subset(two_d_signatures, standard_certificates)}
  end

  def three_d_standard_set
    h={set: build_signature_and_certificate_subset(three_d_signatures, standard_certificates)}
  end

  def two_d_sericel_set
    h={set: build_signature_and_certificate_subset(two_d_signatures, sericel_certificates)}
  end

  def two_d_signatures
    Signature.where(name: two_d_signature_set.flatten).to_a
  end

  def three_d_signatures
    Signature.where(name: three_d_signature_set.flatten).to_a
  end

  def standard_certificates
    Certificate.where(name: standard_certificate_set.flatten).to_a
  end

  def sericel_certificates
    Certificate.where(name: sericel_certificate_set.flatten).to_a
  end

  ###########################################################


  ##############################################################



  # def build_signature_and_certificate
  #   signature_and_certificate_option_groups.each do |h|
  #     origin = find_or_create_by_name(obj_klass: h[:sti], name: h[:name])
  #     if nested_origins = has_kollection?(origin, h[:sti])
  #       existing_set = existing_scoped_targets_set(nested_origins, target_types)
  #       create_missing_and_assoc_opt_with_targets(origin, h[:set], existing_set)
  #     else
  #       create_all_and_assoc_opts_with_targets(origin, h[:set])
  #     end
  #   end
  # end

  # def build_signature_and_certificate_set
  #   set =[]
  #   [[two_d_signature_set, standard_certificate_set], [three_d_signature_set, standard_certificate_set], [two_d_signature_set, sericel_certificate_set]].each do |scoped_set|
  #     build_signature_and_certificate_subset(scoped_set[0], scoped_set[1], set)
  #   end
  #   set
  # end
  #
  # def build_signature_and_certificate_subset(scoped_signature_set, scoped_certificate_set, set)
  #   scoped_certificate_set.each do |certificate_set|
  #     scoped_signature_set.each do |signature_set|
  #       set << [signature_set, certificate_set].flatten
  #     end
  #   end
  #   set.concat(scoped_signature_set).concat(scoped_certificate_set)
  # end

  # def existing_scoped_targets_set(origins, target_types)
  #   origins.map {|origin| target_types.map {|target| has_kollection?(origin, target).to_a.flatten}}.flatten(1)
  # end
  # def assoc_scoped_signature_and_standard_certificate
  #   set =[]
  #   [two_d_signature_set, three_d_signature_set].each do |scoped_signature_set|
  #     assoc_signature_and_standard_certificate(scoped_signature_set, set)
  #   end
  #   set
  # end
  #
  # def assoc_signature_and_standard_certificate(scoped_signature_set, set)
  #   standard_certificate_set.each do |certificate_set|
  #     scoped_signature_set.each do |signature_set|
  #       set << [signature_set, certificate_set].flatten
  #     end
  #   end
  #   set.concat(scoped_signature_set).concat(standard_certificate_set)
  # end
  #
  # def assoc_scoped_signature_and_sericel_certificate
  #   set =[]
  #   [two_d_signature_set].each do |scoped_signature_set|
  #     assoc_signature_and_sericel_certificate(scoped_signature_set, set)
  #   end
  #   set
  # end
  #
  # def assoc_signature_and_sericel_certificate(scoped_signature_set, set)
  #   sericel_certificate_set.each do |certificate_set|
  #     scoped_signature_set.each do |signature_set|
  #       set << [signature_set, certificate_set].flatten
  #     end
  #   end
  #   set.concat(scoped_signature_set).concat(sericel_certificate_set)
  # end

  def product_kind_medium_set
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
