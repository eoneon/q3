module PopProductPartsHelper
  def cat_assocs
    flat_cat_assocs + sculpture_cat_assocs
  end

  def flat_cat_assocs
    flat_items.map {|i| cat_pk_mat_items.map{|sti| append_name(i, sti) } + flat_mount_dim_items}
  end

  def sculpture_cat_assocs
    sculpture_items.map {|i| cat_pk_mat_items.map{|sti| append_name(i, sti) } + sculpture_mount_dim_items}
  end

  ################ structural stuff
  #relevant to :flat_cat_assocs re: flat_mount_dim_items
  def flat_items
    ['Flat', 'Sericel']
  end
  #relevant to signature and certificates (will be)
  # def cat_items
  #   ['Flat', 'Sculpture']
  # end
  ################

  def sculpture_items
    ['HB', 'HM', 'General'].map{|n| append_name(n, 'Sculpture')}
  end

  def cat_pk_mat_items
    ['Category', 'ProductKind', 'Material']
  end

  def flat_mount_dim_items
    ['Mounting', 'Dimension'].map{|sti| append_name('Flat',sti)}
  end

  def sculpture_mount_dim_items
    ['Mounting', 'Dimension'].map{|sti| append_name('Sculpture',sti)}
  end

########################end refactor

  def pp_hash(sti_key, assoc_key)
    h = {product_kind: product_kind_assoc, medium: medium_assoc, material: material_assoc, mounting: mounting_assoc, dimension: dimension_assoc, signature: signature_assoc}
    h[sti_key].assoc(assoc_key).drop(1)
  end

  #mounting_dimension: mounting_dimension_assoc
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

  def signature_assoc
    [['Flat-Signature', 'artist', 'authorized', 'relative', 'famous'], ['Sculpture-Signature', 'artist']]
  end

  def certificate_assoc
    [['General-Certificate'], ['Publisher-Certificate'], ['Animation-Certificate']]
  end

  ##################### product_kind_set

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

  ###################### medium_set
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

  ###################### material_set
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

  ##################### mounting_assoc
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

  #####################
  def sti_cat_group(sti_key)
    h = {signature: signature_assoc}
    h[sti_key].assoc(assoc_key)
  end

  #####################
  # def option_group(sti_key, assoc_key)
  #   h = {signature: signature_opt_idx}
  #   h[sti_key].assoc(assoc_key).drop(1)
  # end

  ##################### start of added methods

  def sti_opt_group(sti_scope:, **opt_keys)
    args = [:hash_key, :assoc_key].map {|k| opt_keys[k]}.compact
    public_send(sti_scope + '_opts', *args)
  end

  def signature_opts(hash_key, assoc_key)
    h = {category: opt_group_values(signature_opt_group), opts: signature_opt_group, opt_idx: signature_opt_idx}
    h[hash_key].assoc(assoc_key).drop(1)
  end

  def certificate_opts(hash_key)
    h = {category: "", opts: certificate_opt_group, opt_idx: ""}
    h[hash_key]
  end

  def edition_opts(hash_key)
    h = {category: "", opts: edition_opt_group, opt_idx: ""}
    h[hash_key]
  end

  def sub_medium_opts(hash_key)
    h = {category: "", opts: sub_medium_opt_group, opt_idx: sub_medium_opt_idx}
    h[hash_key]
  end

  def signature_opt_group
    ['Signature', ['Flat-Signature', 'artist', 'authorized', 'relative', 'famous'], ['Sculpture-Signature', 'artist']]
  end

  def certificate_opt_group
    ['general-certificate', 'publisher-certificate', 'animation-certificate']
  end

  def edition_opt_group
    ['numbered-xy', 'numbered', 'from-an-edition', 'open-edition']
  end

  def sub_medium_opt_group
    ['embellishment', 'leafing', 'remarque']
  end

  def signature_opt_idx
    [['Flat-Signature', [0], [0,0], [0,1], [0,2], [2], [0,3], [3]], ['Sculpture-Signature', [0]]]
  end

  def sub_medium_opt_idx
    [[0,1,2], [0,1], [0,2], [0], [1], [2]]
  end

  def opt_group_values(opt_group)
    opt_group.drop(1).select {|a| a[0]}.flatten
  end

  # def flat_mounting_dimension
  #   ['Flat-MountingDimension', 'flat-mounting-dimension']
  # end
  #
  # def sculpture_mounting_dimension
  #   ['Sculpture-MountingDimension', 'sculpture-mounting-dimension']
  # end
  # def signature_assoc
  #   [flat_signature, sculpture_signature]
  # end
  #edit: item_categories
  # def org_categories
  #   ['Flat-Category', 'Sericel-Category', 'HB-Sculpture-Category', 'HM-Sculpture-Category', 'General-Sculpture-Category']
  # end

  # def org_elements(assoc_key)
  #   [flat_category, sericel_category, hb_sculpture_category, hm_sculpture_category, gen_sculpture_category].assoc(assoc_key).drop(1)
  # end
  #org_elements
  #edit: add Flat-Mounting-Dimension
  # def flat_category
  #   ['Flat-Category', 'Flat-ProductKind', 'Flat-Material', 'Flat-Mounting', 'Flat-Dimension']
  # end
  #
  # def sericel_category
  #   ['Sericel-Category', 'Sericel-ProductKind', 'Sericel-Material', 'Flat-Mounting', 'Flat-Dimension']
  # end
  #
  # def hb_sculpture_category
  #   ['HB-Sculpture-Category', 'HB-Sculpture-ProductKind', 'HB-Sculpture-Material', 'Sculpture-Mounting', 'Sculpture-Dimension']
  # end
  #
  # def hm_sculpture_category
  #   ['HM-Sculpture-Category', 'HM-Sculpture-ProductKind', 'HM-Sculpture-Material', 'Sculpture-Mounting', 'Sculpture-Dimension']
  # end
  #
  # def gen_sculpture_category
  #   ['General-Sculpture-Category', 'General-Sculpture-ProductKind', 'General-Sculpture-Material', 'Sculpture-Mounting', 'Sculpture-Dimension']
  # end
  ###
  # def sculpture_signature_opt_idx
  #   ['Sculpture-Signature', [[0]]]
  # end

  # def sculpture_signature
  #   ['Sculpture-Signature', 'artist']
  # end
end
