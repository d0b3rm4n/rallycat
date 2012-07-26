require "spec_helper"
require "yaml"

describe Rallycat::Connection do

  before do
    @responder = lambda do |env|
      # 'https://rally1.rallydev.com/slm/webservice/current/user'
      [200, {}, ['<foo>bar</foo>']]
    end

    @rc_file_path = File.expand_path("~/.rallycatrc")
  end

  describe '#initialize' do

    it "raises when no config file is present" do
      # Force file to not exist.
      YAML.stub(:load_file).with(@rc_file_path).and_raise(Errno::ENOENT)

      lambda {
        Artifice.activate_with @responder do
          @connection = Rallycat::Connection.new
        end
      }.should raise_error Rallycat::InvalidConfigError,
        "Your rallycat config file is missing or invalid. See 'rallycat help'."
    end

    it "raises when the credentials are invalid" do
      responder = lambda do |env|
        [401, {}, "Invalid, homes."]
      end

      YAML.stub(:load_file).with(@rc_file_path).and_return({
        'username' => "",
        'password' => ""
      })

      lambda {
        Artifice.activate_with responder do
          @connection = Rallycat::Connection.new
        end
      }.should raise_error Rallycat::InvalidCredentialsError,
        "Your Rally credentials are invalid."
    end
  end

  describe "#api" do

    before do
      responder = lambda do |env|
        # 'https://rally1.rallydev.com/slm/webservice/current/user'
        [200, {}, ['<foo>bar</foo>']]
      end

      YAML.stub(:load_file).with(@rc_file_path).and_return({
        'username' => "bitches@rallydev.com",
        'password' => "wesuckatsoftware"
      })


    end

    it "creates a rally connection using user's rallycatrc config file" do
      Artifice.activate_with @responder do
        @connection = Rallycat::Connection.new
      end

      rally_connection = @connection.api

      rally_connection.should be_kind_of(RallyRestAPI)

      rally_connection.username.should eq("bitches@rallydev.com")
      rally_connection.password.should eq("wesuckatsoftware")
    end

    it "creates a rally connection given the username and password provided" do
      Artifice.activate_with @responder do
        @connection = Rallycat::Connection.new("hoes@rallydev.com", "wesuckatpasswords")
      end

      rally_connection = @connection.api

      rally_connection.should be_kind_of(RallyRestAPI)

      rally_connection.username.should eq("hoes@rallydev.com")
      rally_connection.password.should eq("wesuckatpasswords")
    end

  end
end
