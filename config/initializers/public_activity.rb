# для исключения ошибки - Can't mass-assign protected attributes for PublicActivity::Activity: key, parameters, owner, recipient

PublicActivity::Activity.class_eval do
    # attr_accessible :key, :owner, :parameters, :recipient, :trackable
end