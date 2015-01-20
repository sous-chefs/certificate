if defined?(ChefSpec)
  chefspec_version = Gem.loaded_specs['chefspec'].version
  if chefspec_version < Gem::Version.new('4.1.0')
    ChefSpec::Runner.define_runner_method :certificate_manage
  else
    ChefSpec.define_matcher :certificate_manage
  end

  def create_certificate_manage(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:certificate_manage, :create, resource)
  end
end
