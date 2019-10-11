module HashTag
  def update_tags(element, tag_hsh)
    k, v = tag_hsh.keys.first, tag_hsh.values.first
    #puts "#{tag_hsh}"
    if kv_missing?(element.tags) || kv_inequality?(element.tags, k, v)
      kv_missing?(element.tags) ? element.tags = tag_hsh : element.tags.merge!(tag_hsh)
       element.save
    end
    element
  end

  def kv_missing?(tags)
    tags.nil? || tags.empty?
  end

  def kv_inequality?(tags, k, v)
    !tags.has_key?(k) || tags.has_key?(k) && tags[k] != v
  end

  def missing_k?(tags, k)
    !tags.has_key?(k)
  end

  def k_not_eql_v?(tags, k, v)
    tags.has_key?(k) && tags[k] != v
  end
end
