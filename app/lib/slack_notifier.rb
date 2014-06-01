class SlackNotifier < Slack::Notifier

  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  OOPS = [
    'Oops something went wrong',
    'Black-Hawk down, Black-Hawk down',
    'Huston, we\'ve got a problem',
    'On noes',
    'Sheet happens'
  ]

  OOPS_EMOJI = %w[ 
    :japanese_ogre: :japanese_goblin: :imp: :weary: :rage: :smiling_imp: :astonished: :beetle: :bug:
  ]

  class << self
    def enabled?
      Rails.env.production?
    end

    def method_missing(name, *args)
      return unless enabled?
      payload = Settings.slack.send(name)
      payload.merge!(channel: Settings.slack.test) unless Rails.env.production?
      new(payload).send(name, *args)
    rescue => e
      puts e.message, *e.backtrace
    end
  end

  def initialize(payload = {})
    super Settings.slack.team, Rails.application.secrets.slack_token, Settings.slack.hook, payload
  end

  def user_registered(user)
    ping "Hello! I'm #{link_to user.name, admin_user_url(user)}, I've just registered",
    username: user.name,
    icon_url: "http://avatars.io/email/#{user.email}",
    attachments: [
      color: 'good',
      fields: user.identities.map { |i| {
        title: i.provider, 
        value: "<#{i.url}|#{i.handle}>"
      }}
    ]
  end

  def application_received(app)
    user = app.user
    batch = app.batch
    ping "I've just filled a #{link_to "new application", admin_batch_application_url(batch, app)} for #{batch.name}",
    username: user.name,
    icon_url: "http://avatars.io/email/#{user.email}",
    attachments: [
      color: 'good'
    ]
  end

  def application_decided(app, admin)
    batch = app.batch
    ping "I've just updated #{app.user.name}'s #{link_to "application", admin_batch_application_url(batch, app)} to #{batch.name}",
    username: admin.name,
    icon_url: "http://avatars.io/email/#{admin.email}",
    attachments: [
      color: app.accepted ? 'good' : 'danger',
      fields: [{title: {true => 'Accepted', false => 'Rejected', nil => 'Pending'}[app.accepted]}]
    ]    
  end


  def application_rated(app, admin)
    batch = app.batch
    ping "I've just updated #{app.user.name}'s #{link_to "application", admin_batch_application_url(batch, app)} to #{batch.name}",
    username: admin.name,
    icon_url: "http://avatars.io/email/#{admin.email}",
    attachments: [
      fields: [{title: 'New Rating', value: app.rating.to_i}]
    ]    
  end

  def exception_ocurred(exception, options)
    trace = [exception.backtrace.first, 
      exception.backtrace[1..-1].grep(/#{Rails.root}/)[0..3]].flatten.
      map { |s| s[/[^\/]+:in .*/].gsub(/[\(\<\)\>]/, '').split(/:in /) }.
      map { |a| {title: a.first, value: a.last } }
    ping OOPS.sample, icon_emoji: OOPS_EMOJI.sample,
    attachments: [
      fallback: exception.class.name,
      text: exception.message,
      pretext: exception.class.name,
      color: 'danger',
      fields: trace
    ]
  end

  def default_url_options
    Settings.default_url_options
  end

  def url_for(options)
    return options if options.kind_of?(String)
    Rails.application.routes.url_for(options.merge(default_url_options))
  end

end