Pod::Spec.new do |s|
  s.name             = 'Search'
  s.version          = '0.2.0'
  s.summary          = '\'Search\' module.'
  s.homepage         = 'https://github.com/iCookbook/Search'
  s.author           = { 'htmlprogrammist' => '60363270+htmlprogrammist@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/iCookbook/Search.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
  
  s.source_files = 'Search/**/*.{swift}'
  
  s.dependency 'Resources'
  s.dependency 'Networking'
  s.dependency 'Models'
  s.dependency 'CommonUI'
  s.dependency 'RecipeDetails'
end
