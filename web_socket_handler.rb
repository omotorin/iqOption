require 'faye/websocket'

class WebSocketHandler

  def connect(ssid)

    EM.run {
      url = 'wss://iqoption.com/echo/websocket'
      ws = Faye::WebSocket::Client.new(url)

      puts "Connecting to #{ws.url}"

      ws.onopen = lambda do |event|
        p [:open]

        msg={:name => 'ssid', :msg => ssid}.to_json

        ws.send(msg)
      end

      ws.onmessage = lambda do |event|
        begin
          json = JSON.parse event.data
          name = json['name']
          method(name).call(json['msg'])
        rescue NameError
          msg = json['msg']
          message = msg['message'] if msg.is_a?(Hash)
          puts name + ': ' + message[0].to_s if message
          puts name + ': ' + msg.to_s unless message
          #raise e,'No method: '+name
        end
      end

      ws.onclose = lambda do |event|
        p [:close, event.code, event.reason]
        EM.stop
      end
    }
  end

  private
  def profile(msg)
    puts msg
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