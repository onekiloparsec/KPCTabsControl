Pod::Spec.new do |s|
  s.name         = "KPCTabsControl"
  s.version      = "1.6.1"
  s.summary      = "A multi-tabs control designed to look like the tab control in Apple's Numbers spreadsheet, but with enhanced capabilities."
  s.homepage     = "https://github.com/onekiloparsec/KPCTabsControl.git"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Cédric Foellmi" => "cedric@onekilopars.ec" }
  s.source       = { :git => "https://github.com/onekiloparsec/KPCTabsControl.git", :tag => "#{s.version}" }
  s.source_files = 'KPCTabsControl/*.{h,m}'
  s.platform     = :osx, '10.10'
  s.framework    = 'QuartzCore', 'AppKit'
  s.requires_arc = true
  s.resources    = 'Resources/*.pdf'
end
