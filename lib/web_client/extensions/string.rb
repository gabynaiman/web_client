class String

  def demodulize
    if i = self.rindex('::')
      self[(i+2)..-1]
    else
      self
    end
  end

end