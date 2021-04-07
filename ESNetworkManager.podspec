Pod::Spec.new do |s|
s.platform = :ios
#s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
s.ios.deployment_target = '11.0'
s.name = "ESNetworkManager"
s.summary = "ESNetworkManager is a library that depenent on Alamofire that making network request easly to made with response Mapping"
s.requires_arc = true
s.author = { "Mahmoud Eissa" => "mh.eissa90@gmail.com" }
s.homepage = "https://github.com/MahmoudEissa/ESNetworkManager"
s.version = "1.2.6"
#s.social_media_url   = "https://www.linkedin.com/in/mahmoudeissa"
s.source = { :git => "https://github.com/MahmoudEissa/ESNetworkManager.git", :tag => "#{s.version}"}
#s.framework = "Foundation"
#s.source_files = "ESNetworkManager/**/*.{swift}"
#s.resources = "ESNetworkManager/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
s.swift_version = "5.0"
s.license = { :type => "MIT", :file => "LICENSE" }
#s.dependency 'Alamofire', '~> 5.0'
s.default_subspec = "Core"
s.cocoapods_version = '>= 1.4.0'  


s.subspec 'Core' do |ss|
	ss.source_files = "ESNetworkManager/Sources/Core/**/*.{swift}"
        ss.exclude_files = "ESNetworkManager/Sources/Core/**/*.plist"

	ss.dependency 'Alamofire', '~> 5.0'
	ss.framework  = "Foundation"
	 end

s.subspec 'Promise' do |ss|
	ss.source_files = "ESNetworkManager/Sources/ESNetworkManager+Promise/**/*.{swift}"
	ss.dependency 'ESNetworkManager/Core'
	ss.dependency 'PromiseKit/CorePromise', '~> 6.8'
	end

s.subspec 'Rx' do |ss|
	ss.source_files = "ESNetworkManager/Sources/ESNetworkManager+Rx/**/*.{swift}"
	ss.dependency 'ESNetworkManager/Core'
	ss.dependency 'RxSwift', '~> 5'
	end

s.subspec 'ObjectMapper' do |ss|
	ss.source_files = "ESNetworkManager/Sources/ESNetworkManager+ObjectMapper/**/*.{swift}"
	ss.dependency 'ESNetworkManager/Core'
	ss.dependency 'ObjectMapper', '~> 3.5'
	end
end
