class String
  def possessive
    return self if self.empty?
    self + ('s' == self[-1,1] ? "'" : "'s")
  end
end
