class GoogleCredentials
  def initialize(application_name: nil, refresh_key:, scope: nil,
                 client_secret: nil, client_id: nil)
    @application_name = application_name
    @refresh_key = refresh_key
    @scope = scope
    @client_secret = client_secret
    @client_id = client_id
  end

  def self.for_calendar
    return new(
      application_name: 'sheridan',
      refresh_key: 'calendar-analyze',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_SECRET']
    )
  end

  def authorization_url
    params = {
      scope: @scope,
      redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
      response_type: 'code',
      client_id: @client_id
    }
    url = {
      host: 'accounts.google.com',
      path: '/o/oauth2/v2/auth',
      query: URI.encode_www_form(params)
    }

    return URI::HTTPS.build(url)
  end

  def renew_refresh_token(auth_code)
    token = get_new_refresh_token(auth_code)
    puts "new token: #{token}"
    save_refresh_token token
  end

  def get_new_refresh_token(auth_code)
    client = Signet::OAuth2::Client.new(
      token_credential_uri: 'https://www.googleapis.com/oauth2/v3/token',
      code: auth_code,
      client_id: @client_id,
      client_secret: @client_secret,
      redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
      grant_type: 'authorization_code'
    )
    client.fetch_access_token!
    p 'refresh token'
    return client.refresh_token
  end

  def load_user_refresh_credentials
    @credentials = Google::Auth::UserRefreshCredentials.new(
      client_id: @client_id,
      scope: @scope,
      client_secret: @client_secret,
      refresh_token: refresh_token
    )
    @credentials.fetch_access_token!
    return @credentials
  end

  def refresh_token
    @refresh_token ||= `security find-generic-password -wa #{@refresh_key}`.chomp
    @refresh_token
  end

  def save_refresh_token(arg)
    cmd = "security add-generic-password -a '#{@refresh_key}' -s '#{@refresh_key}' -w '#{arg}'"
    system cmd
  end
end
