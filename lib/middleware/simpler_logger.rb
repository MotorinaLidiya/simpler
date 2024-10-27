require 'logger'

class SimplerLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    status, headers, body = @app.call(env)
    @logger.info(log_message(request, status, headers, env))

    [status, headers, body]
  end

  private

  def log_message(request, status, headers, env)
    <<~LOG
      Request: #{request.request_method} #{request.fullpath}
      Handler: #{controller(env)}##{action(env)}
      Parameters: #{request.params.inspect}
      Response: #{status} [#{content_type(headers)}] #{template(env)}
    LOG
  end

  def controller(env)
    env['simpler.controller'] ? env['simpler.controller'].class.name : 'UnknownController'
  end

  def action(env)
    env['simpler.action'] || 'unknown_action'
  end

  def template(env)
    return "#{env['simpler.template']}.html.erb" if env['simpler.template']

    controller_name = env['simpler.controller']&.name || 'unknown_controller'
    action = env['simpler.action'] || 'unknown_action'
    "#{controller_name}/#{action}.html.erb"
  end

  def content_type(headers)
    headers['Content-Type'] || 'unknown_content_type'
  end
end
