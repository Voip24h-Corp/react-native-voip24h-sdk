# react-native-voip24h-sdk.podspec

require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))
parentProject = File.expand_path("..", Dir.pwd)
dirname = File.basename(parentProject)
puts dirname
if dirname == "node_modules"
  parentProject = File.dirname(parentProject)
end
puts parentProject
reactVersion = JSON.parse(File.read(File.join(parentProject, "react-native-voip24h-sdk/example/node_modules", "react-native", "package.json")))["version"]
folly_version = '2021.04.26.00'
boost_compiler_flags = '-Wno-documentation'

rnVersion = reactVersion.split('.')[1]

folly_prefix = ""
if rnVersion.to_i >= 64
  folly_prefix = "RCT-"
end
folly_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -DRNVERSION=' + rnVersion
 
folly_compiler_flags = folly_flags + ' ' + '-Wno-comma -Wno-shorten-64-to-32'

Pod::Spec.new do |s|
  s.name         = "react-native-voip24h-sdk"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-voip24h-sdk
                   DESC
  s.homepage     = "https://github.com/github_account/react-native-voip24h-sdk"
  # brief license entry:
  s.license      = "MIT"
  # optional - use expanded license entry instead:
  # s.license    = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "Phát Nguyễn" => "phat.nguyen@voip24h.vn" }
  s.platforms    = { :ios => "9.0" }
  s.source       = { :git => "https://github.com/github_account/react-native-voip24h-sdk.git", :tag => "#{s.version}" }
  s.source_files = "ios/**/*.{h,c,cc,cpp,m,mm,swift}", "voip-callkit/apple-darwin/share/linphonesw/*.swift"
  s.requires_arc = true

  s.prepare_command = <<-CMD
    curl -O https://dlp.voip24h.vn/voip-callkit-v2.zip
    unzip -o voip-callkit-v2.zip -d voip-callkit
  CMD

  s.vendored_frameworks = "voip-callkit/apple-darwin/XCFrameworks/**"
  s.pod_target_xcconfig = { 'VALID_ARCHS' => "arm64 armv7 x86_64" }
  
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'VALID_ARCHS' => 'arm64 x86_64',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "$(PODS_ROOT)/../voip-callkit/apple-darwin/XCFrameworks"',
    'OTHER_LDFLAGS' => '$(inherited) -framework "bctoolbox" -framework "belle-sip" -framework "belr" -framework "belcard" -framework "ortp" -framework "mediastreamer2" -framework "lime" -framework "linphone"',
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
#    'SWIFT_INCLUDE_PATHS' => '$(PODS_TARGET_SRCROOT)/**',
  }

  s.user_target_xcconfig = {
    'VALID_ARCHS' => 'arm64 x86_64',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "$(PODS_ROOT)/../voip-callkit/apple-darwin/XCFrameworks"'
  }

  # s.subspec 'all-frameworks' do |sp|
  #   sp.vendored_frameworks = "voip-callkit/apple-darwin/Frameworks/**"
  # end

  # s.subspec 'basic-frameworks' do |sp|
  #   sp.dependency 'react-native-voip24h-sdk/app-extension'
  #   sp.vendored_frameworks = "voip-callkit/apple-darwin/Frameworks/{bctoolbox-ios.framework}"
  # end

  # s.subspec 'app-extension' do |sp|
  #   sp.vendored_frameworks = "voip-callkit/apple-darwin/Frameworks/{bctoolbox.framework,belcard.framework,belle-sip.framework,belr.framework,lime.framework,linphone.framework,mediastreamer2.framework,msamr.framework,mscodec2.framework,msopenh264.framework,mssilk.framework,mswebrtc.framework,msx264.framework,ortp.framework}"
  # end

  # s.subspec 'app-extension-swift' do |sp|
  #   sp.source_files = "voip-callkit/apple-darwin/share/linphonesw/*.swift"
  #   sp.dependency "react-native-voip24h-sdk/app-extension"
  #   sp.framework = 'linphone', 'belle-sip', 'bctoolbox'
  # end

  # s.subspec 'swift' do |sp|
  #   sp.dependency "react-native-voip24h-sdk/basic-frameworks"
  #   sp.dependency "react-native-voip24h-sdk/app-extension-swift"
  #   sp.framework = 'bctoolbox-ios'
  # end

  s.pod_target_xcconfig    = {
    "USE_HEADERMAP" => "YES",
    # "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_TARGET_SRCROOT)\" \"$(PODS_ROOT)/#{folly_prefix}Folly\" \"$(PODS_ROOT)/boost\" \"$(PODS_ROOT)/boost-for-react-native\" \"$(PODS_ROOT)/DoubleConversion\" \"$(PODS_ROOT)/Headers/Private/React-Core\" "
    "HEADER_SEARCH_PATHS" => [
      "\"$(inherited)\"",
      "\"$(PODS_TARGET_SRCROOT)\"",
      "\"$(PODS_ROOT)/Headers/Public/React-Core\"",
      "\"$(PODS_ROOT)/Headers/Public/ReactCommon\"",
      "\"$(PODS_ROOT)/#{folly_prefix}Folly\"",
      "\"$(PODS_ROOT)/boost\"",
      "\"$(PODS_ROOT)/DoubleConversion\"",
      "\"$(SRCROOT)/../node_modules/react-native/React/Base\"",
      "\"$(SRCROOT)/../node_modules/react-native/ReactCommon\""
    ].join(' ')
  }
  s.compiler_flags = folly_compiler_flags + ' ' + boost_compiler_flags
  s.xcconfig               = {
    "CLANG_CXX_LANGUAGE_STANDARD" => "c++14",
    "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost\" \"$(PODS_ROOT)/boost-for-react-native\" \"$(PODS_ROOT)/glog\" \"$(PODS_ROOT)/#{folly_prefix}Folly\" \"${PODS_ROOT}/Headers/Public/React-hermes\" \"${PODS_ROOT}/Headers/Public/hermes-engine\"",
                               "OTHER_CFLAGS" => "$(inherited)" + " " + folly_flags  }

  # s.dependency "React"
  # s.dependency 'FBLazyVector'
  # s.dependency 'FBReactNativeSpec'
  # s.dependency 'RCTRequired'
  # s.dependency 'RCTTypeSafety'
  # s.dependency 'React-Core'
  # s.dependency 'React-CoreModules'
  # s.dependency 'React-Core/DevSupport'
  # s.dependency 'React-RCTActionSheet'
  # s.dependency 'React-RCTNetwork'
  # s.dependency 'React-RCTAnimation'
  # s.dependency 'React-RCTLinking'
  # s.dependency 'React-RCTBlob'
  # s.dependency 'React-RCTSettings'
  # s.dependency 'React-RCTText'
  # s.dependency 'React-RCTImage'
  # s.dependency 'React-Core/RCTWebSocket'
  # s.dependency 'React-cxxreact'
  # s.dependency 'React-jsi'
  # s.dependency 'React-jsiexecutor'
  # s.dependency 'React-jsinspector'
  # s.dependency 'ReactCommon/turbomodule/core'
  # s.dependency 'Yoga'

  # if reactVersion.match(/^0.62/)
  #   s.dependency 'ReactCommon/callinvoker'
  # else
  #   s.dependency 'React-callinvoker'
  # end

  # s.dependency "#{folly_prefix}Folly"
  # React Native 0.77+ compatibility
  s.dependency "React-Core"
  s.dependency 'React-Core'
  s.dependency 'React-Core/DevSupport' 
  s.dependency 'React-cxxreact'        
  s.dependency 'React-jsi'             
  s.dependency 'ReactCommon/turbomodule/core'
end
