class String

  def demodulize
    if i = self.rindex('::')
      self[(i+2)..-1]
    else
      self
    end
  end

  def titleize
    "#{self.to_s[0].upcase}#{self[1..-1]}"
  end

end