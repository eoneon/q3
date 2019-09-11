module ItemsHelper
  def build_medium_sets
    medium_set.each do |set|
      h, k, v = {}, 'medium_tier', set[0]
      h[k] = v
      set.drop(1).each do |medium_name|
        medium = find_or_create_by_name(obj_klass: :medium, name: medium_name)
        next if k_exists_v_match?(h: medium.tags, h2: h, k: k, v: v)
        medium.tags = update_hash(h: medium.tags, h2: h, k: k, v: v)
        medium.save
      end
    end
  end

  def update_hash(h:, h2:, k:, v:)
    if k_exists_v_mismatch?(h: h, h2: h2, k: k, v: v) || kv_none?(h: h, h2: h2, k: k, v: v)
      h.merge(h2)
    else
      h2
    end
  end

  def tag_set
    ['original', 'limited-edition', 'print', 'animation', 'two-d', 'three-d']
  end

  def medium_set
    [primary_media, secondary_media, component_media]
  end

  def primary_media
    ['primary', 'original', 'painting', 'drawing', 'monoprint', 'production', 'one-of-a-kind', 'mixed-media', 'limited-edition', 'print', 'hand-pulled', 'hand-made-ceramic', 'hand-blown-glass', 'photography', 'sculpture', 'sculpture-type', 'animation', 'sericel']
  end

  def secondary_media
    ['secondary', 'embellishment', 'remarque']
  end

  def component_media
    ['diptych', 'triptych', 'quadriptych', 'set']
  end

  #policies?
  def k_exists_v_match?(h:, h2:, k:, v:)
    h && h.present? && h.has_key?(k) && h[k] == v
  end

  def k_exists_v_mismatch?(h:, h2:, k:, v:)
    h && h.has_key?(k) && h[k] != v
  end

  def kv_none?(h:, h2:, k:, v:)
    h && !h.has_key?(k)
  end
end
