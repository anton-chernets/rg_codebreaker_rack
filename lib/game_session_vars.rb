module GameSessionVars
  def player_name
    @request.session[:player_name]
  end

  def player_name=(name)
    @request.session[:player_name] = name
  end

  def game
    @request.session[:game]
  end

  def game=(value)
    @request.session[:game] = value
  end

  def attempts
    @request.session[:attempts]
  end

  def attempts=(value)
    @request.session[:attempts] = value
  end

  def current_attempts
    @request.session[:current_attempts]
  end

  def current_attempts=(value)
    @request.session[:current_attempts] = value
  end

  def guess
    @request.session[:guess]
  end

  def guess=(value)
    @request.session[:guess] = value
  end

  def game_log
    @request.session[:game_log]
  end

  def game_log=(value)
    @request.session[:game_log] = value
  end

  def hint
    @request.session[:hint]
  end

  def hint=(value)
    @request.session[:hint] = value
  end

  def won
    @request.session[:won]
  end

  def won=(value)
    @request.session[:won] = value
  end

  def game_over
    @request.session[:game_over]
  end

  def game_over=(value)
    @request.session[:game_over] = value
  end
end
