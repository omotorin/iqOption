require './service/SocketHandler'
require './app/IQAccount'

class IQApp

  def initialize
    @@account = IQAccount.new
  end

  def self.account
    @@account
  end

  private
  def connect
    @sockethadler = SocketHandler.new
  end

  public
  def run
    auth = AuthRequest.new
    auth.perfom('', '') #email, password
    connect
  end

end
