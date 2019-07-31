module PopProductPartsHelper
  def org_categories
    ['Flat-Category', 'Sericel-Category', 'HB-Sculpture-Category', 'HM-Sculpture-Category', 'General-Sculpture-Category']
  end

  def org_elements(assoc_key)
    [flat_category, sericel_category, hb_sculpture_category, hm_sculpture_category, gen_sculpture_category].assoc(assoc_key).drop(1)
  end

  def pp_hash(sti_key, assoc_key)
    h = {product_kind: product_kind_assoc, medium: medium_assoc, material: material_assoc, mounting: mounting_assoc, dimension: dimension_assoc, mounting_dimension: mounting_dimension_assoc}
    h[sti_key].assoc(assoc_key).drop(1)
  end

  #####################
  def product_kind_assoc
    [flat_pk, sericel_pk, hb_sculpture_pk, hm_sculpture_pk, gen_sculpture_pk]
  end

  def medium_assoc
    [original_med, one_of_a_kind_med, print_med, prod_sericel_med, gen_sericel_med, hand_blown_med, hand_made_med, gen_sculpt_med]
  end

  def material_assoc
    [flat_mat, hb_sculpture_mat, hm_sculpture_mat, gen_sculpt_mat, sericel_mat]
  end

  def mounting_assoc
    [flat_mounting, sculpture_mounting]
  end

  def dimension_assoc
    [flat_dimension, sculpture_dimension]
  end

  def mounting_dimension_assoc
    [flat_mounting_dimension, sculpture_mounting_dimension]
  end

  #org_elements
  def flat_category
    ['Flat-Category', 'Flat-ProductKind', 'Flat-Material', 'Flat-Mounting', 'Flat-Dimension']
  end

  def sericel_category
    ['Sericel-Category', 'Sericel-ProductKind', 'Sericel-Material', 'Flat-Mounting', 'Flat-Dimension']
  end

  def hb_sculpture_category
    ['HB-Sculpture-Category', 'HB-Sculpture-ProductKind', 'HB-Sculpture-Material', 'Sculpture-Mounting', 'Sculpture-Dimension']
  end

  def hm_sculpture_category
    ['HM-Sculpture-Category', 'HM-Sculpture-ProductKind', 'HM-Sculpture-Material', 'Sculpture-Mounting', 'Sculpture-Dimension']
  end

  def gen_sculpture_category
    ['General-Sculpture-Category', 'General-Sculpture-ProductKind', 'General-Sculpture-Material', 'Sculpture-Mounting', 'Sculpture-Dimension']
  end
  ###

  #####################
  #org_product_parts(product_kind)
  #product_kind_set
  def flat_pk
    ['Flat-ProductKind', 'original art', 'one-of-a-kind art', 'print-media']
  end

  def sericel_pk
    ['Sericel-ProductKind', 'production-sericel', 'sericel']
  end

  def hb_sculpture_pk
    ['HB-Sculpture-ProductKind', 'hand-blown glass media']
  end

  def hm_sculpture_pk
    ['HM-Sculpture-ProductKind', 'hand-made ceramic media']
  end

  def gen_sculpture_pk
    ['General-Sculpture-ProductKind', 'general-sculpture media']
  end

  #####################
  #org_product_parts(medium)
  #medium_set
  def original_med
    ['original art', 'painting', 'sketch']
  end

  def one_of_a_kind_med
    ['one-of-a-kind art', 'mixed-media', 'hand-pulled prints', 'hand-pulled prints', 'monoprints']
  end

  def print_med
    ['print-media', 'premium-prints', 'generic-prints', 'hand-pulled prints', 'posters', 'photos']
  end

  def prod_sericel_med
    ['production-sericel', 'production-sericel & sketch']
  end

  def gen_sericel_med
    ['sericel']
  end

  def hand_blown_med
    ['hand-blown glass media', 'hand-blown glass', 'gartner-blade media']
  end

  def hand_made_med
    ['hand-made ceramic media', 'hand-made ceramic']
  end

  def gen_sculpt_med
    ['general-sculpture media', 'general-sculpture']
  end

  #####################
  #org_product_parts(material)
  #material_set
  def flat_mat
    ['Flat-Material', 'canvas', 'paper', 'board', 'metal']
  end

  def hb_sculpture_mat
    ['HB-Sculpture-Material', 'hand-blown glass']
  end

  def hm_sculpture_mat
    ['HM-Sculpture-Material', 'hand-blown ceramic']
  end

  def gen_sculpt_mat
    ['General-Sculpture-Material', 'general-sculpture material']
  end

  def sericel_mat
    ['Sericel-Material', 'sericel']
  end

  #####################
  #org_product_parts(mounting)
  #mounting_assoc
  def flat_mounting
    ['Flat-Mounting', 'framed', 'bordered', 'wrapped', 'matting']
  end

  def sculpture_mounting
    ['Sculpture-Mounting', 'case', 'base']
  end

  def flat_dimension
    ['Flat-Dimension', 'flat-dimension']
  end

  def sculpture_dimension
    ['Sculpture-Dimension', 'sculpture-dimension']
  end

  def flat_mounting_dimension
    ['Flat-Mounting-Dimension', 'flat-mounting-dimension']
  end

  def sculpture_mounting_dimension
    ['Sculpture-Mounting-Dimension', 'sculpture-mounting-dimension']
  end
end
