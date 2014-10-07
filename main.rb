require './login'
require './web_socket_handler'

ssid = Login.auth 'oleg.motorin@gmail.com','Mkzmkz12'
wsh = WebSocketHandler.new
wsh.connect(ssid)
