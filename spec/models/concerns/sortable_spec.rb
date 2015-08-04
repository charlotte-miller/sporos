require 'rails_helper'

describe Sortable do
  # Using Channel as a representative sample
  it_behaves_like 'it is Sortable', {klass:Channel}
  it_behaves_like 'it is Sortable', {klass:Meeting, scoped_to:'group'}
end
