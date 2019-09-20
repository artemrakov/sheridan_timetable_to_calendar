class Login
  attr_reader :username_id, :password_id, :submit

  def initialize(username_id:, password_id:, submit:)
    @username_id = username_id
    @password_id = password_id
    @submit = submit
  end

  def run(browser)
    browser.text_field(id: username_id).set(ENV['USERNAME'])
    browser.text_field(id: password_id).set(ENV['PASSWORD'])
    browser.input(class: submit).click
  end
end
