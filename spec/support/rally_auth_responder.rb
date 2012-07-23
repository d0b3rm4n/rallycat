class RallyAuthResponder < GenericResponder

  def call(env)
    @requests << request = Rack::Request.new(env)
    if request.url == 'https://rally1.rallydev.com/slm/webservice/current/user'
      [200, {}, ['<User><DisplayName></DisplayName></User>']]
    else
      [500, {}, ['oh noes']]
    end
  end
end
