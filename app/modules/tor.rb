require 'socksify/http'

module Tor
  def http
    @http ||= Net::HTTP::SOCKSProxy('127.0.0.1', 9050)
  end

  def generate_new_tor_circuit
		localhost = Net::Telnet::new("Host" => "localhost","Port" => "#{9051}", "Timeout" => 10, "Prompt" => /250 OK\n/)
		localhost.cmd('AUTHENTICATE ""') { |c| print c; throw "Cannot authenticate to Tor" if c != "250 OK\n" }
		localhost.cmd('signal NEWNYM') { |c| print c; throw "Cannot switch Tor to new route" if c != "250 OK\n" }
		localhost.close
  end
end
