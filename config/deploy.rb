set :application, 'devf'
set :repo_url, %x{git config remote.origin.url}.chomp

ask :branch, proc { 
  current = `git rev-parse --abbrev-ref HEAD`.chomp 
}

set :scm, :git

set :format, :pretty
set :log_level, :debug
set :pty, true
set :git_shallow_clone, 1

set :linked_files, %w{config/database.yml config/secrets.yml .env }
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

squirrels = [
  "https://img.skitch.com/20111026-r2wsngtu4jftwxmsytdke6arwd.png",
  "http://images.cheezburger.com/completestore/2011/11/2/aa83c0c4-2123-4bd3-8097-966c9461b30c.jpg",
  "http://images.cheezburger.com/completestore/2011/11/2/46e81db3-bead-4e2e-a157-8edd0339192f.jpg",
  "http://28.media.tumblr.com/tumblr_lybw63nzPp1r5bvcto1_500.jpg",
  "http://i.imgur.com/DPVM1.png",
  "http://gifs.gifbin.com/092010/1285616410_ship-launch-floods-street.gif",
  "http://d2f8dzk2mhcqts.cloudfront.net/0772_PEW_Roundup/09_Squirrel.jpg",
  "http://www.cybersalt.org/images/funnypictures/s/supersquirrel.jpg",
  "http://www.zmescience.com/wp-content/uploads/2010/09/squirrel.jpg",
  "http://img70.imageshack.us/img70/4853/cutesquirrels27rn9.jpg",
  "http://img70.imageshack.us/img70/9615/cutesquirrels15ac7.jpg",
  "https://dl.dropboxusercontent.com/u/602885/github/sniper-squirrel.jpg",
  "http://1.bp.blogspot.com/_v0neUj-VDa4/TFBEbqFQcII/AAAAAAAAFBU/E8kPNmF1h1E/s640/squirrelbacca-thumb.jpg",
  "https://dl.dropboxusercontent.com/u/602885/github/soldier-squirrel.jpg",
  "https://dl.dropboxusercontent.com/u/602885/github/squirrelmobster.jpeg",
  "http://f.cl.ly/items/0S1M2d1h0I132S082A05/flying-squirrel.gif"
]
set :slack_token, "8jlTCVSt0lQuxqM81kOtuz4a" # comes from inbound webhook integration
set :slack_team, "devf"
#set :slack_icon_url,     ->{ squirrels.sample }
set :slack_icon_emoji,   ->{ ':shipit:' } # will override icon_url
set :slack_channel,      ->{ '#sitio-web-devf' }
set :slack_username,     ->{ 'Shipit' }
set :slack_run_starting, ->{ true }
set :slack_run_finished, ->{ true }
set :slack_run_failed,   ->{ true }
set :slack_msg_starting, ->{ "#{ENV['USER'] || ENV['USERNAME']} has started deploying branch #{fetch :branch} of #{fetch :application} to #{fetch :rails_env, 'production'}." }
set :slack_msg_finished, ->{ "#{ENV['USER'] || ENV['USERNAME']} has finished deploying branch #{fetch :branch} of #{fetch :application} to #{fetch :rails_env, 'production'}. #{squirrels.sample}" }
set :slack_msg_failed,   ->{ "*ERROR!* #{ENV['USER'] || ENV['USERNAME']} failed to deploy branch #{fetch :branch} of #{fetch :application} to #{fetch :rails_env, 'production'}." }


# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

fetch(:default_env).merge!(rails_env: fetch(:stage))

server "devf-#{fetch(:stage)}", roles: %w{web app}, ssh_options: { forward_agent: true }

namespace :deploy do
  #task :restart => 'puma:restart'
  after :finishing, 'deploy:cleanup'
end
