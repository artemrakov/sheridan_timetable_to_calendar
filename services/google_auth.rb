class GoogleAuth
  def initialize(application_name: nil, scope: nil,
                 client_secret: nil, client_id: nil)
    @application_name = application_name
    @scope = scope
    @client_secret = client_secret
    @client_id = client_id
  end

  def self.for_calendar
    return new(
      application_name: 'sheridan',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_SECRET']
    )
  end

  def authorization_url
    URI::HTTPS.build(url)
  end

  def renew_refresh_token(auth_code)
    token = get_new_refresh_token(auth_code)
    save_refresh_token(token)
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
    return client.refresh_token
  end

  def load_user_refresh_credentials(refresh_token)
    @credentials = Google::Auth::UserRefreshCredentials.new(
      client_id: @client_id,
      scope: @scope,
      client_secret: @client_secret,
      refresh_token: refresh_token
    )
    @credentials.fetch_access_token!
    @credentials
  end

  private

  def params
    {
      scope: @scope,
      redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
      response_type: 'code',
      client_id: @client_id
    }
  end

  def url
    {
      host: 'accounts.google.com',
      path: '/o/oauth2/v2/auth',
      query: URI.encode_www_form(params)
    }
  end
end
