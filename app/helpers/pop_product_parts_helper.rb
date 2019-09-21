module PopProductPartsHelper
  ##################################################################  tags_hash methods
  def sti_opts
    ['medium', 'material', 'edition', 'signature', 'dimension', 'mounting', 'certificate']
  end

  def tags_hash
    h = {medium_tags: medium_tags, material_tags: material_tags, edition_tags: edition_tags, signature_tags: signature_tags, dimension_tags: dimension_tags, mounting_tags: mounting_tags, certificate_tags: certificate_tags, product_kind_tags: product_kind_tags}
  end

  ##############################

  def medium_tags
    h = {medium_type: scoped_medium_types}
  end

  def material_tags
    h = {dimension_tags: scoped_material_dimension_types, medium_assoc: scoped_material_medium_assoc}
  end

  def edition_tags
    h = {edition_type: scoped_edition_types}
  end

  def signature_tags
    h = {signature_type: scoped_signature_types}
  end

  def dimension_tags
    h = {dimension_type: scoped_dimension_types}
  end

  def mounting_tags
    h = {mounting_type: scoped_mounting_dimension_types}
  end

  def certificate_tags
    h = {certificate_type: scoped_certificate_types}
  end

  def product_kind_tags
    h = {material_assoc: scoped_medium_material_assoc}
  end

  ##############################

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
    [two_d_materials.prepend('true'), three_d_materials.prepend('true')]
  end

  def scoped_edition_types
    [limited_edition.prepend('limited-edition'), open_edition, single_edition]
  end

  def scoped_signature_types
    [flat_signatures.prepend('two-d'), sculpture_signatures.prepend('three-d')]
  end

  def scoped_dimension_types
    [two_dimensions.prepend('two-d'), three_dimensions.prepend('three-d')]
  end

  def scoped_mounting_dimension_types
    [two_dimension_mountings.prepend('two-d'), three_dimension_mountings.prepend('three-d')]
  end

  def scoped_certificate_types
    [basic_certificates.prepend('basic_coa'), publisher_certificates.prepend('publisher_coa'), animation_certificates.prepend('animation_coa')]
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
    flat_signatures | sculpture_signatures
  end

  def flat_signatures
    ['artist', 'authorized', 'relative', 'famous']
  end

  def sculpture_signatures
    ['artist']
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
    ['framed', 'bordered', 'matted']
  end

  def three_dimension_mountings
    ['case', 'base']
  end

  ########################################################### certificate name sets

  def certificate_names
    basic_certificates | publisher_certificates | animation_certificates
  end

  def basic_certificates
    ['basic-certificate']
  end

  def publisher_certificates
    ['publisher-certificate']
  end

  def animation_certificates
    ['animation-seal', 'sports-seal', 'animation-certificate', 'basic-certificate']
  end

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
   ['hand-blown'],
   ['hand-made'],
   ['sculpture'],
   ['embellished', 'sculpture'],
   ['limited-edition', 'sculpture'],
   ['embellished', 'limited-edition', 'sculpture']]
  end
end
