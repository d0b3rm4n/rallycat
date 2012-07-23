class GenericResponder
  attr_reader :requests

  def initialize
    @requests = []
  end

  def last_request
    @requests.last
  end

  def call(env)
    # does not record the requests
    [200, {}, ['']]
  end
end
