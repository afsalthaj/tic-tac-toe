class Utils
  def self.deep_copy(object)
    Marshal.load(Marshal.dump(object))
  end
end