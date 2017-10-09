platform :ios, '10.0'
inhibit_all_warnings!

target 'Lemon' do
  use_frameworks!

  # Pods for Lemon
  pod 'MBProgressHUD'
  pod 'R.swift'
  pod 'Texture'
  pod 'MarkdownView', :git => 'git@github.com:X140Yu/MarkdownView.git', :commit => 'e94fc4f54b9b1ec9002e01ea0ff8a4da5e058a75'
  pod 'SnapKit', '~> 3.0'

  pod 'Fabric'
  pod 'Crashlytics'

  # Rx
  pod 'Moya/RxSwift'
  pod 'RxAlamofire'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'RxOptional'
  pod 'Moya-ObjectMapper/RxSwift'


  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.2'
      end
    end
  end



  target 'LemonTests' do
    inherit! :search_paths
  end

end
