class GenericResponder
  attr_reader :requests

  def initialize
    @requests = []
  end

  def last_request
    @requests.last
  end

  def call(env)
    [200, {}, ['']]
  end
end
