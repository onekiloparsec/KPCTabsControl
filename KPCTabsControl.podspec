Pod::Spec.new do |s|
  s.name         = "KPCTabsControl"
  s.version      = "5.0.0"
  s.summary      = "A multi-tabs control with enhanced capabilities, and custom styles."
  s.homepage     = "https://github.com/onekiloparsec/KPCTabsControl.git"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Cédric Foellmi" => "cedric@onekilopars.ec" }
  s.source       = { :git => "https://github.com/onekiloparsec/KPCTabsControl.git", :tag => "#{s.version}" }
  s.source_files = 'KPCTabsControl/*.{swift}'
  s.platform     = :osx, '10.14'
  s.framework    = 'QuartzCore', 'AppKit'
  s.resources    = 'Resources/*.pdf'
  s.swift_version = '5'
end
