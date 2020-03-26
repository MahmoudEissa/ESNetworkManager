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
#s.source = { :git => "https://github.com/MahmoudEissa/ESNetworkManager.git", :branch => 'Development', :tag => "#{s.version}"}
s.framework = "Foundation"
s.source_files = "ESNetworkManager/**/*.{swift}"
s.resources = "ESNetworkManager/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
s.swift_version = "5.0"
s.license = { :type => "MIT", :file => "LICENSE" }
s.dependency 'Alamofire', '~> 5.0'

s.subspec 'Core' do |ss|
	ss.dependency 'Alamofire', '~> 5.0'
	ss.source_files = "ESNetworkManager/Sources/Core/**/*.{swift}"
	ss.resources = "ESNetworkManager/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
	 end

s.subspec 'Promise' do |ss|
	ss.dependency 'PromiseKit/CorePromise', '~> 6.8'
	ss.source_files = "ESNetworkManager/Sources/ESNetworkManager+Promise/**/*.{swift}"
	end
s.subspec 'Rx' do |ss|
	ss.source_files = "ESNetworkManager/Sources/ESNetworkManager+Rx/**/*.{swift}"
	ss.dependency 'RxSwift', '~> 5'
	end
s.subspec 'ObjectMapper' do |ss|
	ss.source_files = "ESNetworkManager/Sources/ESNetworkManager+ObjectMapper/**/*.{swift}"
	ss.dependency 'ObjectMapper', '~> 3.5'
	end
end
