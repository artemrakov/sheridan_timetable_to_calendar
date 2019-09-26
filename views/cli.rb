class CLI
  def success
    puts 'All done!'
  end

  def processing
    puts 'Processing...'
  end

  def ask_for_calendar_index(calendar_list)
    puts 'Select calendar'

    calendar_list.each_with_index do |calendar, index|
      puts "#{index + 1} #{calendar[:summary]}"
    end

    gets.strip.to_i - 1
  end

  def ask_to_authorize(url)
    puts "Go to #{url}"
    puts 'Paste in the authorization code'

    gets.strip
  end

  def display_token(token)
    puts "new token: #{token}"
  end
end
