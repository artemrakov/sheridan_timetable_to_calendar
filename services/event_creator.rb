require_relative 'calendar'

class EventCreator
  def initialize(lessons)
    @lessons = lessons
  end

  def self.run(lessons)
    new(lessons).call
  end

  def call
    @lessons.map do |lesson|
      Calendar::Event.new attributes_for_event(lesson)
    end
  end

  private

  def attributes_for_event(lesson)
    {
      summary: "#{lesson.name} #{lesson.location}",
      start: {
        date_time: lesson.start_time.to_s
      },
      end: {
        date_time: lesson.end_time.to_s
      }
    }
  end
end
