require 'haml'
require 'yaml'
require 'codebreaker'
require_relative 'game_session_vars'
require_relative 'routes'

# codebreaker web app
class App
  include GameSessionVars
  attr_reader :scores

  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
    @game_data_file_path = File.join(__dir__, 'game_data.yml')
    @scores = {}
  end

  def response
    page = Routes::APP_ROUTES[@request.path]
    page ? page.call(self) : Rack::Response.new(render('errors/404'), 404)
  end

  def index
    if @request.params['player_name']
      unless game
        self.game = Codebreaker::Game.new do |configuration|
          configuration.player_name = @request.params['player_name'].strip
        end
        self.player_name = game.instance_variable_get(:@configuration).player_name
        self.attempts = game.instance_variable_get(:@attempts)
      end
    end
    self.current_attempts = game.instance_variable_get(:@current_attempts)
    Rack::Response.new(render('index'), 200)
  end

  def attempts_guess
    self.guess = @request.params['breaker_code']
    result_guess = game&.submits_guess(guess)
    add_to_log(result_guess)
    if result_guess == true
      self.won = 1
      self.game_over = 1
    elsif result_guess == false
      self.game_over = 1
    end
    redirect_to '/'
  end

  def add_to_log(res)
    self.game_log = game_log || []
    game_log << [guess, res]
  end

  def request_hint
    received_hint = game&.gives_hint
    self.hint = received_hint if received_hint
    redirect_to '/'
  end

  def plays_again
    @request.session.clear
    redirect_to '/'
  end

  def saves_result
    File.open(@game_data_file_path, 'w') { |f| f.write YAML.dump(game&.preparation_information) }
    @request.session.clear
    redirect_to '/scores'
  end

  def display_scores
    @scores = YAML.load_file(File.open(@game_data_file_path, 'r')) if File.file?(@game_data_file_path)
    Rack::Response.new(render 'game_scores')
  end

  def render(template)
    path = File.expand_path("../views/#{template}.html.haml", __FILE__)
    Haml::Engine.new(File.read(path)).render(binding)
  end

  def redirect_to(path)
    Rack::Response.new do |response|
      response.redirect(path.to_s)
    end
  end
end
