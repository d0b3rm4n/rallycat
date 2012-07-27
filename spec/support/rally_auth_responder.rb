class RallyAuthResponder < GenericResponder

  def call(env)
    @requests << request = Rack::Request.new(env)

    case request.path
    when '/slm/webservice/current/user'
      [200, {}, ['<User><DisplayName></DisplayName></User>']]
    else
      [500, {}, ['No user was found']]
    end
  end
end
