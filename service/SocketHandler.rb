require 'websocket-eventmachine-client'
require 'eventmachine'
require 'json'
require './request/IQUrlConstants'
require './app/IQApp'

class SocketHandler

  def initialize
    connect
  end

  private
  def connect

    EM.epoll
    EM.run do

      ws = WebSocket::EventMachine::Client.connect(:uri => IQUrlConstants::HOST + 'echo/websocket')

      ws.onopen do
        puts "Connected"
        msg = {:name => 'ssid', :msg => IQApp.account.sessionId}.to_json
        ws.send msg
      end

      ws.onmessage do |msg, type|
        begin
          json = JSON.parse msg
          name = json['name']
          method(name).call(json['msg'])
        rescue NameError
          msgJson = json['msg']
          message = msgJson['message'] if msgJson.is_a?(Hash)
          puts name + ': ' + message[0].to_s if message
          puts name + ': ' + msgJson.to_s unless message
          #raise e,'No method: '+name
        end
      end

      ws.onclose do
        puts "Disconnected"
        stop
      end

      ws.onerror do |e|
        puts "Error: #{e}"
      end

      ws.onping do |msg|
        puts "Receied ping: #{msg}"
      end

      ws.onpong do |msg|
        puts "Received pong: #{msg}"
      end

    end

  end

  def stop
    puts "Terminating connection"
    EventMachine.stop
  end

  private
  def profile(msg)
    #puts msg
    IQApp.relogin unless msg.is_a?(Hash)

    account = IQApp.account
    account.userId = msg['user_id']
    account.email = msg['email']
    account.firstName = msg['first_name']
    account.lastName = msg['last_name']
    account.currencyChar = msg['currency_char']
    account.balance = msg['balance']
    account.groupId = msg['group_id']
    account.isDemo = msg['demo'] == 1 ? true : false
    account.locale = msg['locale']
    account.currency_id = msg['currency_id']
    account.currency = msg['currency']
    account.countryId = msg['country_id']
    phone = msg['phone'].split(' ')
    if phone.size > 1
      account.countryCode = phone[0]
      account.phone = phone[1]
    end
    account.city = msg['city']
    account.address = msg['address']
    account.zip = msg['postal_index']
    account.gender = msg['gender']
    #this.main.tradeRoom.showUserInfo()
    #this.main.slideFragment.notifyAdapter()
    initGraphIfNeeded
    if account.isDemo
        readPopup(msg)
    end
  end

  def initGraphIfNeeded
    # code here
  end

  def readPopup(msg)
    # code here
  end

  def timeSync(msg)
    time = Time.at(msg/1000)
    p time
  end

  def newChartData(msg)
    puts msg
  end

  def timeChange(msg)
    puts msg
  end

  def initDataChart(msg)
    puts msg
  end

  def buyComplete(msg)
    puts msg
  end

  def listInfoData(msg)
    puts msg
  end

  def recconnect(msg)
    puts msg
  end

  def feedRecentBets(msg)
    puts msg
  end

end


