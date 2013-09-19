Pod::Spec.new do |s|
  s.name         = "Fountain"
  s.version      = "1.0.1"
  s.summary      = "An open source implementation of the Fountain screenplay formatting language."
  s.homepage     = "http://fountain.io"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Nima Yousefi" => "inbox@nimayousefi.com" }
  s.source       = { :git => "https://github.com/nyousefi/Fountain.git", :tag => "v#{spec.version}" }
  s.platform     = :osx
  s.source_files = "Fountain/FN*.{h,m}", "Fountain/Fountain*.{h,m}", "Fountain/FastFountainParser.{h,m}", "RegexKitLite/*.{h,m}"
  s.frameworks   = 'cocoa'
  s.libraries    = 'icucore'
  s.requires_arc = true
end