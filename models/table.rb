require './services/lesson_parser'

class Table
  CLASS_FOR_LECTURE = 'SSSTEXTWEEKLY'
  attr_reader :rows, :cols

  def initialize(rows:, cols:)
    @rows = rows
    @cols = cols
  end

  def dates
    @dates ||= take_dates_from_header
  end

  def lessons
    @lessons ||= extract_classes_from_table
  end

  private

  def header
    rows[0]
  end

  def header_columns
    ths = header.ths
    ths[1..ths.length]
  end

  def take_dates_from_header
    header_columns.map do |col|
      parse_date(col.text)
    end
  end

  def parse_date(string)
    date = string.split("\n")[1]
    Chronic.parse(date)
  end

  def extract_classes_from_table
    rows_length = (1...rows.size)
    cols_length = (1...cols.size)
    lessons = []

    rows_length.each do |row|
      cols_length.each do |col|
        span = rows[row].tds[col].span(class: CLASS_FOR_LECTURE)
        # passing the date with col - 1 as cols are shifted and dates are not
        lessons << parse_lesson(span.text, dates[col - 1]) if span.present?
      end
    end

    lessons
  end

  def parse_lesson(string, date)
    LessonParser.run(string, date)
  end
end
