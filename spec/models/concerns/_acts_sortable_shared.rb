require 'rails_helper'
require 'set'

shared_examples 'it is Sortable' do |options|
  before(:all) do
    options = {
      klass: described_class,
      factory_name:nil,
      scoped_to:nil
    }.merge(options || {})

    @klass   = options[:klass]
    @factory = options[:factory_name] ||= @klass.to_s.downcase.to_sym
    @factory_options = {}

    if @scoped_to = options[:scoped_to].try(:to_sym)
      @scoped_to_model = build_stubbed(@scoped_to)
      @factory_options.merge!({@scoped_to=> @scoped_to_model})
    end
  end

  subject {build_stubbed(@factory)}
  it {is_expected.to have_db_column(:position)}

  it 'assigns a position on_create' do
    expect(2.times.map {create(@factory, @factory_options)}.map(&:position)).to eql [1,2]
  end

  it 'queries sort by position by default' do
    expect(@klass.where('').to_sql).to match /ORDER BY position ASC/
  end

  it 'compares by position' do
    higher      = create(@factory, @factory_options)
    lower       = create(@factory, @factory_options)

    expect(higher > lower).to be true
    expect(higher < lower).to be false

    if @scoped_to
      other_scope = create(@factory, @factory_options.merge({@scoped_to=> build_stubbed(@scoped_to)}))
      expect { higher > other_scope }.to raise_error ArgumentError, "Can't compare across scopes"
    end
  end
end
