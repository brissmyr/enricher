class Array
  def to_json(options = {})
    "[#{map { |obj| obj.respond_to?(:to_json) ? obj.to_json(options) : obj }.join(',')}]"
  end
end
