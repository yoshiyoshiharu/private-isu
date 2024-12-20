require_relative './app.rb'

# cf: https://github.com/rack/rack/issues/1994
class DropContentTypeFromGet
  def initialize(app)
    @app = app
  end

  def call(env)
    env.delete "CONTENT_TYPE" if env.fetch('REQUEST_METHOD') == 'GET'
    @app.call(env)
  end
end

use DropContentTypeFromGet
use StackProf::Middleware, enabled: true,
                           mode: :cpu,
                           interval: 1000,
                           save_every: 5
run Isuconp::App
