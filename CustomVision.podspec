Pod::Spec.new do |s|

  s.name          = 'CustomVision'
  s.version       = '1.0.0'
  s.summary       = 'Microsoft Azure Custom Vision client SDKs for iOS.'

  s.description   = 'Microsoft Azure Custom Vision client SDKs for iOS, macOS, watchOS, tvOS.'

  s.homepage      = 'https://github.com/colbylwilliams/CustomVision'
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = 'Colby Williams'
  
  s.source        = { :git => 'https://github.com/colbylwilliams/CustomVision.git', :tag => "v#{s.version}" }

  s.swift_version = '5.0'

  s.source_files = 'CustomVision/CustomVision/*.{swift,h,m}'
  
  s.ios.deployment_target     = '11.3'
  s.osx.deployment_target     = '10.13'
  s.tvos.deployment_target    = '11.3'
  s.watchos.deployment_target = '4.3'
  
end
