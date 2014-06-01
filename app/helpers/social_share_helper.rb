module SocialShareHelper

  SOCIAL_SHARE_URLS = {
    "facebook"    => "http://www.facebook.com/sharer.php?u=%{url}&t=%{title}",
    "twitter"     => "http://twitter.com/share?url=%{url}&text=%{title}",
    "google_plus" => "https://plus.google.com/share?url=%{url}",
    "linkedin"    => "http://www.linkedin.com/shareArticle?url=%{url}"
  }

  SOCIAL_SHARE_LABELS = {
    "facebook"    => "Facebook",
    "twitter"     => "Twitter",
    "google_plus" => "Google Plus",
    "linkedin"    => "LinkedIn"
  }

  def social_share_urls(title, url, *networks)
    networks = SOCIAL_SHARE_URLS.keys unless networks.present?
    public_url   = CGI.escape(url.to_s)
    networks.map do |network|
      if share_url = SOCIAL_SHARE_URLS[network.to_s]
        share_url = share_url % {:url => public_url, title: title} 
        yield SOCIAL_SHARE_LABELS[network.to_s], share_url, network if block_given?
        share_url
      end
    end.compact
  end

end