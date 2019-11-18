require './services/event_creator'

class ApplicationController
  REFRESH_KEY = 'calendar-analyze'

  attr_accessor :service
  attr_reader :google_auth, :sheridan, :view

  def initialize(google_auth, service, sheridan, view)
    @google_auth = google_auth
    @service = service
    @sheridan = sheridan
    @view = view
  end

  def run
    login_to_google
    calendar_index = view.ask_for_calendar_index(calendars)
    add_events(calendars[calendar_index])
    view.success
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
    view.ask_to_authorize(google_auth.authorization_url)
    refresh_token = google_auth.renew_refresh_token(auth_code)
    view.display_token(refresh_token)
    save_refresh_token(refresh_token)
  end

  def save_refresh_token(arg)
    cmd = "security add-generic-password -a '#{REFRESH_KEY}' -s '#{REFRESH_KEY}' -w '#{arg}'"
    system cmd
  end

  def calendars
    @calendars ||= calendar_lists
  end

  def calendar_lists
    items = service.list_calendar_lists.to_h[:items]
    items.map do |item|
      item
    end
  end

  def add_events(calendar)
    id = calendar[:id]
    lessons = sheridan.lessons
    events = EventCreator.run(lessons)

    events.each do |event|
      service.insert_event(id, event)
    end
  end
end
