require 'open-uri'
require 'net/http'
require 'net/https'
require 'json'
require './app/IQApp'

class AuthRequest
  def perfom(email, password)
    uri = URI.parse("https://iqoption.com/api/login")
    https = Net::HTTP.new(uri.host,uri.port)
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path)
    req['User-Agent'] = 'User-Agent" => "Mozilla/5.0 (Windows NT 6.3; rv:32.0) Gecko/20100101 Firefox/32.0'
    req['Accept'] = 'application/json, text/plain, */*'

    req.set_form_data('email' => email, 'password' => password, 'remember_me' => 1)

    res = https.request(req)

    cookie = res['set-cookie']

    /ssid=(?<ssid>\w+)/ =~ cookie

    account = IQApp.account
    account.email=email
    account.password=password
    account.sessionId=ssid
  end
end