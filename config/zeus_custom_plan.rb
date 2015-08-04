require 'zeus/rails'

class CustomPlan < Zeus::Rails
  def test
    require 'simplecov'
    SimpleCov.start 'rails' do
      coverage_dir 'spec/coverage'
    end

    # require all ruby files
    Dir["#{Rails.root}/lib|app/**/*.rb"].each { |f| load f }

    # run the tests
    super
  end
end

Zeus.plan = CustomPlan.new
