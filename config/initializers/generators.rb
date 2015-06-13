Rails.application.config.generators do |g|
  g.test_framework :minitest,
                   fixtures: false,
                   view_specs: false,
                   helper_specs: false,
                   routing_specs: false,
                   controller_specs: false,
                   request_specs: false

  g.fixture_replacement :factory_girl, dir: 'test/factories'
  g.stylesheets false
  g.javascripts false
end
