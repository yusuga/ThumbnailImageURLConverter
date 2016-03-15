Pod::Spec.new do |s|
  s.name = 'ThumbnailImageURLConverter'
  s.version = '0.0.3'
  s.summary = 'Convert the URL to the thumbnail URL.'
  s.homepage = 'https://github.com/yusuga/ThumbnailImageURLConverter'
  s.license = 'MIT'
  s.author = 'Yu Sugawara'
  s.source = { :git => 'https://github.com/yusuga/ThumbnailImageURLConverter.git', :tag => s.version.to_s }
  s.platform = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.source_files = 'Classes/ThumbnailImageURLConverter/**/*.{h,m}'
  s.requires_arc = true
  s.compiler_flags = '-fmodules'  
end