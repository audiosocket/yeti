Pod::Spec.new do |s|
  s.name         = 'Yeti'
  s.version      = '0.2.0'
  s.summary      = 'iOS SDK for the Audiosocket REST API'
  s.author       = { 'Charlie Morss' => 'cmorss@audiosocket.com' }
  s.source       = { :git => 'https://github.com/audiosocket/yeti.git', :tag => 'v0.2.0' }
  s.source_files = 'Yeti', 'Yeti/models/*.{h,m}'
  s.requires_arc = true

#  Would like this dependency here, but we run into issue with managed
#  code and ARC code in the same pod.

#  s.dependency     'RestKit', '~> 0.20.0pre'
end
