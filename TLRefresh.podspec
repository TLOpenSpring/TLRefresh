#
# Be sure to run `pod lib lint TLRefresh.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TLRefresh'
  s.version          = '2.0.0'
  s.summary          = '针对UItableview和UICollectionView的上拉加载，下拉刷新的类库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
"上拉加载，下拉刷新，在swift中使用超级简单，只需一行代码，就能加入这个功能，API简单易用"
                       DESC

  s.homepage         = 'https://github.com/TLOpenSpring/TLRefresh'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Andrew' => 'anluanlu123@163.com' }
  s.source           = { :git => 'https://github.com/TLOpenSpring/TLRefresh.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TLRefresh/**/*'
  
 s.resource_bundles = {
   'TLRefresh' => ['TLRefresh/Assets/*.png']
}

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'Willow', '~> 1.1.0'
end
