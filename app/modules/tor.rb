require 'socksify/http'

module Tor
  class Http
    def self.get(uri)
      resp = get_request(uri)

      resp = self.get_request(URI(resp['location'])) if resp.code == '301'

      resp.body
    end

    def self.get_request(uri)
      resp = Net::HTTP.SOCKSProxy('127.0.0.1', 9050).start(uri.host, uri.port, use_ssl: true) do |http|
        http.get(uri)
      end
    end
  end

  def http
    @http ||= Http
  end

  def generate_new_tor_circuit
		localhost = Net::Telnet::new("Host" => "localhost","Port" => "#{9051}", "Timeout" => 10, "Prompt" => /250 OK\n/)
		localhost.cmd('AUTHENTICATE ""') { |c| print c; throw "Cannot authenticate to Tor" if c != "250 OK\n" }
		localhost.cmd('signal NEWNYM') { |c| print c; throw "Cannot switch Tor to new route" if c != "250 OK\n" }
		localhost.close
  end
end
