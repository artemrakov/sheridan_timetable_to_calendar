class Table
  attr_reader :rows, :cols

  def initialize(rows:, cols:)
    @rows = rows
    @cols = cols
  end

  def dates
    @dates ||= take_dates_from_header
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
    Chronic.parse(string.split("\n")[1])
  end
end
