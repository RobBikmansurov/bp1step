#https://github.com/mbleigh/acts-as-taggable-on/issues/389
# fix error "WARNING: Can't mass-assign protected attributes for ActsAsTaggableOn"
module ActsAsTaggableOn
  class Tag
    # attr_accessible :name
  end

  class Tagging
    # attr_accessible :tag_id, :context, :taggable
  end
end