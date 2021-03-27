Pod::Spec.new do |s|
  s.name         = "IAMenuController"
  s.version      = "0.5.0"
  s.summary      = "A simple slide out menu controller container."
  s.homepage     = "https://github.com/TheLevelUp/IAMenuController"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Mark Adams" => "mark@thoughtbot.com" }
  s.source       = { :git => "https://github.com/TheLevelUp/IAMenuController.git", :tag => "#{s.version}" }
  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.source_files = 'IAMenuController/**/*.{swift}'
  s.framework    = 'QuartzCore'
end
