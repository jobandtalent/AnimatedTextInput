Pod::Spec.new do |s|
  s.name             = 'AnimatedTextInput'
  s.version          = '0.5.4'
  s.summary          = 'UITextField and UITextView replacement with animated hint and error message support. Highly customizable. Used in Jobandtalent iOS app'

  s.description      = <<-DESC
AnimatedTextInput
This custom control can be used as a replacement for UITextField or UITextView. It comes with 5 different entry types: default, numeric, password, selection and multiline, but you can also extend its functionality by setting up your own TextInput.
The animation consists on the placeholder becoming the hint. This control also allows for error state, showing an error message hint.
DESC

  s.homepage         = 'https://github.com/jobandtalent/AnimatedTextInput'
  s.screenshots      = 'https://github.com/jobandtalent/AnimatedTextInput/raw/master/Assets/general.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Victor Baro' => 'fs.baro@gmail.com' }
  s.source           = { :git => 'https://github.com/jobandtalent/AnimatedTextInput.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/jobandtalentEng'

  s.ios.deployment_target = '8.0'

  s.source_files = 'AnimatedTextInput/Classes/**/*'

  s.resource_bundles = {
    'AnimatedTextInput' => ['AnimatedTextInput/Assets/*.*']
  }
end
