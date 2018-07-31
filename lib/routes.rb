module Routes
  APP_ROUTES = {
    '/' => ->(instance) { instance.index },
    '/attempts' => ->(instance) { instance.attempts_guess },
    '/hint' => ->(instance) { instance.request_hint },
    '/again' => ->(instance) { instance.plays_again },
    '/save' => ->(instance) { instance.saves_result },
    '/scores' => ->(instance) { instance.display_scores }
  }.freeze
end
