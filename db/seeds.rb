class Seed
  FIXTURES = File.join 'db', 'fixtures'

  def initialize(options)
    @symbol = options[:symbol]
    @file = File.join FIXTURES, "#{@symbol.to_s.pluralize}.xml"
    @query = options[:query] || '//xs:enumeration'
    @model = @symbol.to_s.capitalize.constantize
    @field = options[:field] || 'value'
  end

  def plant
    Nokogiri::XML(IO.read @file).
    xpath(@query).each do |node|
      @model.find_or_create_by_name(node[@field])
    end
  end
end

[
  :format,
  :type,
].each do |symbol|
  seed = Seed.new :symbol => symbol
  seed.plant
end
