if defined?(ChefSpec)
  ChefSpec::Runner.define_runner_method :certificate_manage

  def create_certificate_manage(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:certificate_manage, :create, resource)
  end
end
