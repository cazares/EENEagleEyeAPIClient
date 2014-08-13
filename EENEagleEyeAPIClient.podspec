Pod::Spec.new do |s|
  s.name         = "EENEagleEyeAPIClient"
  s.summary      = "An API wrapper for the Eagle Eye Networks API."
  s.version      = "0.0.1"
  s.homepage     = "http://www.eagleeyenetworks.com/cloud-video-surveillance-API/"
  s.license      = 'Apache 2.0'
  s.authors      = { "Miguel Cazares" => "mcazares@eagleeyenetworks.com",}
  s.source       = { :git => "https://github.com/cazares/EENEagleEyeAPIClient.git", :tag => "#{s.version}" }

  s.source_files = 'EENEagleEyeAPIClient/*.{h,m}'
  s.requires_arc = true

  s.dependency 'AFNetworking', '~> 2.2.0'
  s.ios.deployment_target = '7.0'
end
