# config.middleware.use ActionDispatch::Session::CookieStore
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '104328285020-33sltd07ke9do6ng5n2304rivt3g3s00.apps.googleusercontent.com', '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', redirect_uri: 'http://localhost:3000/auth/google_oauth2/callback',
    scope: 'email profile',
    prompt: 'select_account'
  # OmniAuth.config.allowed_request_methods = %i[get]
end
