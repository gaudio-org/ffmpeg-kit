Pod::Spec.new do |s|
  s.name             = 'ffmpeg_kit_flutter_full'
  s.version          = '6.0.3'
  s.summary          = 'FFmpeg Kit for Flutter'
  s.description      = 'A Flutter plugin for running FFmpeg and FFprobe commands.'
  s.homepage         = 'https://github.com/arthenica/ffmpeg-kit'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'ARTHENICA' => 'open-source@arthenica.com' }

  s.platform            = :ios
  s.requires_arc        = true
  s.static_framework    = true

  s.source              = { :path => '.' }
  s.source_files        = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'

 #   s.default_subspec     = 'https'
 # FFmpegKit has been officially retired.Place iOS dependent libraries locally to solve compilation problems
  s.default_subspec = 'ffmpeg_kit_ios_local'

  s.subspec 'ffmpeg_kit_ios_local' do |ss|
    # ss.vendored_frameworks = 'Frameworks/ffmpeg-kit-ios-https/ffmpegkit.xcframework', 'Frameworks/ffmpeg-kit-ios-https/libavdevice.xcframework', 'Frameworks/ffmpeg-kit-ios-https/libavcodec.xcframework', 'Frameworks/ffmpeg-kit-ios-https/libavfilter.xcframework', 'Frameworks/ffmpeg-kit-ios-https/libavformat.xcframework', 'Frameworks/ffmpeg-kit-ios-https/libavutil.xcframework', 'Frameworks/ffmpeg-kit-ios-https/libswresample.xcframework', 'Frameworks/ffmpeg-kit-ios-https/libswscale.xcframework'
    ss.vendored_frameworks = 'Frameworks/ffmpeg-kit-ios-lame/ffmpegkit.xcframework', 'Frameworks/ffmpeg-kit-ios-lame/libavdevice.xcframework', 'Frameworks/ffmpeg-kit-ios-lame/libavcodec.xcframework', 'Frameworks/ffmpeg-kit-ios-lame/libavfilter.xcframework', 'Frameworks/ffmpeg-kit-ios-lame/libavformat.xcframework', 'Frameworks/ffmpeg-kit-ios-lame/libavutil.xcframework', 'Frameworks/ffmpeg-kit-ios-lame/libswresample.xcframework', 'Frameworks/ffmpeg-kit-ios-lame/libswscale.xcframework'
  end

  s.dependency          'Flutter'
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    # 'FRAMEWORK_SEARCH_PATHS' => '"$(PODS_TARGET_SRCROOT)/Frameworks/ffmpeg-kit-ios-full/**"',
    # 'LD_RUNPATH_SEARCH_PATHS' => '@executable_path/Frameworks',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'
  }

  s.subspec 'min' do |ss|
    ss.source_files         = 'Classes/**/*'
    ss.public_header_files  = 'Classes/**/*.h'
    ss.dependency 'ffmpeg-kit-ios-min', "6.0"
    ss.ios.deployment_target = '12.1'
  end

  s.subspec 'min-lts' do |ss|
    ss.source_files         = 'Classes/**/*'
    ss.public_header_files  = 'Classes/**/*.h'
    ss.dependency 'ffmpeg-kit-ios-min', "6.0.LTS"
    ss.ios.deployment_target = '10'
  end

  s.subspec 'min-gpl' do |ss|
    ss.source_files         = 'Classes/**/*'
    ss.public_header_files  = 'Classes/**/*.h'
    ss.dependency 'ffmpeg-kit-ios-min-gpl', "6.0"
    ss.ios.deployment_target = '12.1'
  end

  s.subspec 'min-gpl-lts' do |ss|
    ss.source_files         = 'Classes/**/*'
    ss.public_header_files  = 'Classes/**/*.h'
    ss.dependency 'ffmpeg-kit-ios-min-gpl', "6.0.LTS"
    ss.ios.deployment_target = '10'
  end

  s.subspec 'https' do |ss|
    ss.source_files         = 'Classes/**/*'
    ss.public_header_files  = 'Classes/**/*.h'
    ss.dependency 'ffmpeg-kit-ios-https', "6.0"
    ss.ios.deployment_target = '12.1'
  end

  s.subspec 'https-lts' do |ss|
    ss.source_files         = 'Classes/**/*'
    ss.public_header_files  = 'Classes/**/*.h'
    ss.dependency 'ffmpeg-kit-ios-https', "6.0.LTS"
    ss.ios.deployment_target = '10'
  end

  s.subspec 'https-gpl' do |ss|
    ss.source_files         = 'Classes/**/*'
    ss.public_header_files  = 'Classes/**/*.h'
    ss.dependency 'ffmpeg-kit-ios-https-gpl', "6.0"
    ss.ios.deployment_target = '12.1'
  end

  s.subspec 'https-gpl-lts' do |ss|
    ss.source_files         = 'Classes/**/*'
    ss.public_header_files  = 'Classes/**/*.h'
    ss.dependency 'ffmpeg-kit-ios-https-gpl', "6.0.LTS"
    ss.ios.deployment_target = '10'
  end

  s.subspec 'audio' do |ss|
    ss.source_files         = 'Classes/**/*'
    ss.public_header_files  = 'Classes/**/*.h'
    ss.dependency 'ffmpeg-kit-ios-audio', "6.0"
    ss.ios.deployment_target = '12.1'
  end

  s.subspec 'audio-lts' do |ss|
    ss.source_files         = 'Classes/**/*'
    ss.public_header_files  = 'Classes/**/*.h'
    ss.dependency 'ffmpeg-kit-ios-audio', "6.0.LTS"
    ss.ios.deployment_target = '10'
  end

  s.subspec 'video' do |ss|
    ss.source_files         = 'Classes/**/*'
    ss.public_header_files  = 'Classes/**/*.h'
    ss.dependency 'ffmpeg-kit-ios-video', "6.0"
    ss.ios.deployment_target = '12.1'
  end

  s.subspec 'video-lts' do |ss|
    ss.source_files         = 'Classes/**/*'
    ss.public_header_files  = 'Classes/**/*.h'
    ss.dependency 'ffmpeg-kit-ios-video', "6.0.LTS"
    ss.ios.deployment_target = '10'
  end

  s.subspec 'full' do |ss|
    ss.source_files         = 'Classes/**/*'
    ss.public_header_files  = 'Classes/**/*.h'
    ss.dependency 'ffmpeg-kit-ios-full', "6.0"
    ss.ios.deployment_target = '12.1'
  end

  s.subspec 'full-lts' do |ss|
    ss.source_files         = 'Classes/**/*'
    ss.public_header_files  = 'Classes/**/*.h'
    ss.dependency 'ffmpeg-kit-ios-full', "6.0.LTS"
    ss.ios.deployment_target = '10'
  end

  s.subspec 'full-gpl' do |ss|
    ss.source_files         = 'Classes/**/*'
    ss.public_header_files  = 'Classes/**/*.h'
    ss.dependency 'ffmpeg-kit-ios-full-gpl', "6.0"
    ss.ios.deployment_target = '12.1'
  end

  s.subspec 'full-gpl-lts' do |ss|
    ss.source_files         = 'Classes/**/*'
    ss.public_header_files  = 'Classes/**/*.h'
    ss.dependency 'ffmpeg-kit-ios-full-gpl', "6.0.LTS"
    ss.ios.deployment_target = '10'
  end

end
