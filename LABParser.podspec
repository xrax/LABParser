Pod::Spec.new do |s|
  s.name             = 'LABParser'
  s.version          = '1.0'
  s.summary          = 'Simple JSON-Dictionary parser.'
  s.description      = "Bidirectional JSON-Dictionary parser development in swift 4."

  s.homepage         = 'https://github.com/xrax/LABParser'
  
  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license          = { :type => 'MIT', :file => 'LICENSE' }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author             = { "Leonardo Armero Barbosa" => "limpusra@gmail.com" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform     = :ios, "11.0"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4' }

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source           = { :git => 'https://github.com/xrax/LABParser.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = 'LABParser/*.swift', 'LABParser/*.xib'
  
  # s.resource_bundles = {
  #   'LABMenu' => ['LABMenu/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
