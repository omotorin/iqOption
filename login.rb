require 'net/http'
require 'net/https'
require 'json'

class Login
  def self.auth(email, password)
    uri = URI('https://iqoption.com/api/login')
    res = post_form(uri, 'email' => email, 'password' => password)

    msg = JSON.parse(res.body)

    raise 'Authorization error: ' + msg['message'].join('\n') unless msg['isSuccessful']

    cookie = res['set-cookie'].to_s
    /ssid=(?<ssid>\w+);/ =~ cookie
    ssid
  end

  private
  def self.post_form(url, params)
    req = Net::HTTP::Post.new(url)
    req.form_data = params
    req.basic_auth url.user, url.password if url.user
    Net::HTTP::start(url.hostname, url.port,
          {:use_ssl => url.scheme == 'https',:verify_mode => OpenSSL::SSL::VERIFY_NONE} ) {|http|
      http.request(req)
    }
  end

end