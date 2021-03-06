# encoding: utf-8

# cookbook:: rvm
if defined?(ChefSpec)
  def create_rvm_environment(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:rvm_environment, :create, resource_name)
  end # def

  def install_rvm_global_gem(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:rvm_global_gem, :install, resource_name)
  end # def

end # if
