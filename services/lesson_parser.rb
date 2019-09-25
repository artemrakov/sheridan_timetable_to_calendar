require './models/lesson'

class LessonParser
  TIME_ZONE = '-04:00'
  attr_reader :data, :day_of_the_week

  def initialize(string, day_of_the_week)
    @data = string.split("\n")
    @day_of_the_week = day_of_the_week
  end

  def self.run(string, day_of_the_week)
    new(string, day_of_the_week).call
  end

  def call
    name, type, time, location = data[2], data[3], data[4], data[5]
    start_of_the_lesson, end_of_the_lesson = time.split(" - ").map { |e| Time.parse(e) }

    start_time = DateTime.new(year, month, day, start_of_the_lesson.hour, start_of_the_lesson.min, 0, TIME_ZONE)
    end_time = DateTime.new(year, month, day, end_of_the_lesson.hour, end_of_the_lesson.min, 0, TIME_ZONE)

    Lesson.new(name: name, type: type, start_time: start_time, end_time: end_time, location: location)
  end

  private

  def month
    day_of_the_week.mon
  end

  def year
    day_of_the_week.year
  end

  def day
    day_of_the_week.day
  end
end
