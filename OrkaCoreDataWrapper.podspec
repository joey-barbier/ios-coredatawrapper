Pod::Spec.new do |s|
  s.name = 'OrkaCoreDataWrapper'
  s.version = '1.0.1'
  s.authors = 'Joey Barbier'
  s.summary = 'simple lib for search in CoreData'
  s.homepage = 'https://github.com/joey-barbier/ios-coredatawrapper'
  s.license = 'BSD 3'
  
  s.platform = :ios
  s.ios.deployment_target = '13.0'
  
  s.source = { :git => 'https://github.com/joey-barbier/ios-coredatawrapper.git', :tag => s.version.to_s }
  s.swift_version = '5.0'
  
  s.requires_arc = true
  s.frameworks = 'Foundation'
  s.frameworks = 'CoreData'
  
  s.source_files = 'Package/Sources/**/*.swift'
end
