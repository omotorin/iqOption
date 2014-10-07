require 'net/http'
require 'net/https'
require 'json'

#OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class Login
  def self.auth(email, password)
    uri = URI('https://iqoption.com/api/login')
    res = post_form(uri, 'email' => email, 'password' => password)
    res.body
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