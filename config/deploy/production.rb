server '104.155.231.199'
user = "jagi"
ipaddress = "104.155.231.199"
role :app, ["#{user}@#{ipaddress}"]
role :web, ["#{user}@#{ipaddress}"]
role :db,  ["#{user}@#{ipaddress}"]

set :ssh_options, {
  keys: %w(/Users/yinaura/.ssh/id_rsa),
  forward_agent: true,
}
