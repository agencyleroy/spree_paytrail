# -*- encoding: utf-8 -*-
# stub: spree_paytrail 1.1.2 ruby lib

Gem::Specification.new do |s|
  s.name = "spree_paytrail"
  s.version = "1.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Joakim Runeberg"]
  s.date = "2014-10-02"
  s.description = "Spree extension for integration with Paytrail"
  s.email = "joakim@pinkdog.fi"
  s.files = ["LICENSE", "README.md", "app/controllers", "app/controllers/spree", "app/controllers/spree/checkout_controller_decorator.rb", "app/models", "app/models/spree", "app/models/spree/billing_integration", "app/models/spree/billing_integration/paytrail", "app/models/spree/billing_integration/paytrail/paytrail_checkout.rb", "app/models/spree/gateway", "app/models/spree/gateway/paytrail.rb", "app/models/spree/paytrail_transaction.rb", "app/views", "app/views/spree", "app/views/spree/admin", "app/views/spree/admin/orders", "app/views/spree/admin/orders/_pp_standard_txns.html.erb", "app/views/spree/checkout", "app/views/spree/checkout/_jsredirect.html.erb", "app/views/spree/checkout/edit.html.erb", "app/views/spree/checkout/payment", "app/views/spree/checkout/payment/_paytrailcheckout.html.erb", "app/views/spree/paytrail_payments", "app/views/spree/paytrail_payments/successful.html.erb", "lib/active_merchant", "lib/active_merchant/billing", "lib/active_merchant/billing/verkkomaksut.rb", "lib/generators", "lib/generators/spree_paytrail", "lib/generators/spree_paytrail/install", "lib/generators/spree_paytrail/install/install_generator.rb", "lib/spree_paytrail", "lib/spree_paytrail.rb", "lib/spree_paytrail/engine.rb"]
  s.homepage = "http://github.com/eoy/spree_paytrail"
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.requirements = ["none"]
  s.rubygems_version = "2.2.2"
  s.summary = "Spree extension for integration with Paytrail"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activemerchant>, [">= 0"])
      s.add_runtime_dependency(%q<browser>, [">= 0"])
      s.add_development_dependency(%q<capybara>, ["= 1.0.1"])
      s.add_development_dependency(%q<factory_girl>, [">= 0"])
      s.add_development_dependency(%q<ffaker>, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 2.7"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
    else
      s.add_dependency(%q<activemerchant>, [">= 0"])
      s.add_dependency(%q<browser>, [">= 0"])
      s.add_dependency(%q<capybara>, ["= 1.0.1"])
      s.add_dependency(%q<factory_girl>, [">= 0"])
      s.add_dependency(%q<ffaker>, [">= 0"])
      s.add_dependency(%q<rspec-rails>, ["~> 2.7"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
    end
  else
    s.add_dependency(%q<activemerchant>, [">= 0"])
    s.add_dependency(%q<browser>, [">= 0"])
    s.add_dependency(%q<capybara>, ["= 1.0.1"])
    s.add_dependency(%q<factory_girl>, [">= 0"])
    s.add_dependency(%q<ffaker>, [">= 0"])
    s.add_dependency(%q<rspec-rails>, ["~> 2.7"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
  end
end
