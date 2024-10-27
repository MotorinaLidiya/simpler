module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @pattern = path_pattern(path)
      end

      def match?(method, path, env)
        match = path.match(@pattern)
        return false unless @method == method && match

        @params = match.named_captures.transform_keys(&:to_sym)
        env['simpler.params'] = @params
      end

      private

      def path_pattern(path)
        Regexp.new("^#{path.gsub('/', '\/').gsub(/:(\w+)/, '(?<\1>[^/]+)')}$")
      end

    end
  end
end
