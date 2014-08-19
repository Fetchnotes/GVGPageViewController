
Pod::Spec.new do |s|
  s.name             = "GVGPageViewController"
  s.version          = "0.1.0"
  s.summary          = "better than uipageviewcontroller"
  s.homepage         = "https://github.com/Fetchnotes/GVGPageViewController"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'Private'
  s.author           = { "Giles Van Gruisen" => "giles@fetchnotes.com" }
  s.source           = { :git => "https://github.com/Fetchnotes/GVGPageViewController.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'src'

  
end
