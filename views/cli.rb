require './services/event_creator'

class CLI
  REFRESH_KEY = 'calendar-analyze'

  attr_accessor :service
  attr_reader :google_auth, :sheridan

  def initialize(google_auth, service, sheridan)
    @google_auth = google_auth
    @service = service
    @sheridan = sheridan
  end

  def run
    login_to_google
    calendar_id = select_calendar_id
    add_events(calendar_id)
    success
  end

  private

  def login_to_google
    acquire_refresh_token if refresh_token.nil? || refresh_token.empty?
    authorize
  end

  def refresh_token
    @refresh_token ||= `security find-generic-password -wa #{REFRESH_KEY}`.chomp
    @refresh_token
  end

  def authorize
    auth_client = google_auth.load_user_refresh_credentials(refresh_token)
    service.authorization = auth_client
  end

  def acquire_refresh_token
    puts "Go to #{google_auth.authorization_url}"
    puts 'Paste in the authorization code'
    auth_code = gets.strip

    refresh_token = google_auth.renew_refresh_token(auth_code)
    puts "new token: #{refresh_token}"
    save_refresh_token(refresh_token)
  end

  def save_refresh_token(arg)
    cmd = "security add-generic-password -a '#{REFRESH_KEY}' -s '#{REFRESH_KEY}' -w '#{arg}'"
    system cmd
  end

  def select_calendar_id
    puts 'Select calendar where you want to add Sheridan timetable'
    items = service.list_calendar_lists.to_h[:items]
    items.each_with_index do |item, index|
      puts "#{index + 1}. #{item[:summary]}"
    end

    calendar_number = gets.strip.to_i
    items[calendar_number - 1][:id]
  end

  def success
    puts 'All done!'
  end

  def add_events(calendar_id)
    lessons = sheridan.lessons
    events = EventCreator.run(lessons)

    puts 'Processing...'

    events.each do |event|
      service.insert_event(calendar_id, event)
    end
  end
end
