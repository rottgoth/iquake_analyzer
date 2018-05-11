class IquakeAnalyzer

  attr_reader :data

  def initialize
    @data = UsgsClient.new.fetch_data
  end

  def list_california_earthquakes
    # alternative approach
    # data.group_by { |earthquake| earthquake[:city] }['CA']
    data.select { |earthquake| earthquake[:city] == 'CA' }
        .sort { |a, b| b[:mag] <=> a[:mag] }
  end
end