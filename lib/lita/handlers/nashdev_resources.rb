module Lita
  module Handlers
    class NashdevResources < Handler
      ISSUE_URL = URI.parse('https://api.github.com/repos/maxbeizer/nashdev-resources/issues').freeze

      route(/resource(?: me)?\s+(.*)/, :handle_resource_request, command: true, help: {
        'resource me <link>' => 'creates an issue on the nashdev resources repo'
      })

      def handle_resource_request(response)
        resources = response.args.delete_if { |arg| arg == 'me' }
        data      = build_json_for_request(response.user, resources)
        res       = request_and_return_response(data)
        response.reply(res)
      end

      private
      def request_and_return_response(data)
        res = post_issue_to_repo(data)
        handle_response(res)
      end

      def post_issue_to_repo(data)
        Net::HTTP.start(ISSUE_URL.host, ISSUE_URL.port, use_ssl: true) do |https|
          req = Net::HTTP::Post.new(ISSUE_URL, {
            'Content-Type'  => 'application/json',
            'User-Agent'    => 'maxbeizer',
            'Accept'        => 'application/vnd.github.v3+json',
            'Authorization' => "token #{ENV[RESOURCE_ISSUE_TOKEN]}"
          })
          req.body = data
          https.request(req)
        end
      end

      def handle_response(res)
        if res.code == '201'
          url = JSON.parse(res.body)['html_url']
          "I've created your request to add to the resources: #{url}"
        else
          'I was unable to create your request to add a resources :crying_cat_face:'
        end
      end

      def build_json_for_request(user, resources)
        {
          "title" => "New resource request from Slack user: #{user.mention_name}",
          "body" => resources.join(' ')
        }.to_json
      end
    end

    Lita.register_handler(NashdevResources)
  end
end
