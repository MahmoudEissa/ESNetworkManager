Pod::Spec.new do |s|
s.platform = :ios
s.ios.deployment_target = '12.0'
s.name = "ESNetworkManager"
s.summary = "ESNetworkManager is a library that depenent on Alamofire that making network request easly to made with response Mapping"
s.requires_arc = true
s.author = { "Mahmoud Eissa" => "mh.eissa90@gmail.com" }
s.homepage = "https://github.com/MahmoudEissa/APIClient"
s.version = "0.1.0"
s.social_media_url   = "www.linkedin.com/in/mahmoudeissa"
s.source = { :git => "https://github.com/MahmoudEissa/ESNetworkManager", :branch => 'Development', :tag => "#{s.version}"}
s.framework = "Foundation"
s.dependency 'Alamofire', '~> 5.0'
s.source_files = "ESNetworkManager/**/*.{swift}"
s.resources = "ESNetworkManager/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
s.swift_version = "5.0"
s.license = { :type => "MIT", :file => "LICENSE" }
end
