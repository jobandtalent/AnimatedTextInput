#
# Be sure to run `pod lib lint AnimatedTextInput.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AnimatedTextInput'
  s.version          = '0.1.0'
  s.summary          = 'UITextField and UITextView replacement with animated hint and error message support. Highly customizable. Used in Jobandtalent iOS app'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    # AnimatedTextInput
This custom control can be used as a replacement for UITextField or UITextView. It comes with 5 different entry types: default, numeric, password, selection and multiline, but you can also extend its functionality by setting up your own TextInput.
The animation consists on the placeholder becoming the hint. This control also allows for error state, showing an error message hint.


  s.homepage         = 'https://github.com/jobandtalent/AnimatedTextInput'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Victor Baro' => 'fs.baro@gmail.com' }
  s.source           = { :git => 'https://github.com/jobandtalent/AnimatedTextInput.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/jobandtalentEng'

  s.ios.deployment_target = '8.0'

  s.source_files = 'AnimatedTextInput/Classes/**/*'

  # s.resource_bundles = {
  #   'AnimatedTextInput' => ['AnimatedTextInput/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  s.dependency 'PureLayout', '~> '3.0'
end
