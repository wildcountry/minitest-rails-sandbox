Rails.application.config.generators do |g|
  g.test_framework :minitest,
                   fixtures: false,
                   view_specs: false,
                   helper_specs: false,
                   routing_specs: false,
                   controller_specs: false,
                   request_specs: false

  g.factory_girl false
  g.stylesheets false
  g.javascripts false
end
