require 'net/http'
require 'net/https'
require 'json'

#OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class Login
  def self.auth(email, password)
    uri = URI('https://iqoption.com/api/login')
    res = Net::HTTP.post_form(uri, 'email' => email, 'password' => password) {|http| http.verify_mode = OpenSSL::SSL::VERIFY_NONE}
    res.body
  end
end