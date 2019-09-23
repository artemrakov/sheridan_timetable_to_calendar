class Lesson
  attr_reader :name, :type, :start_time, :end_time, :location

  def initialize(name:, type:, start_time:, end_time:, location:)
    @name = name
    @type = type
    @start_time = start_time
    @end_time = end_time
    @location = location
  end
end
