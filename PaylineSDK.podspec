#
# Be sure to run `pod lib lint PaylineSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

  s.name             = 'PaylineSDK'
  s.version          = '1.0.0'
  s.license          = { :type => 'GPL', :file => 'LICENSE' }

  s.summary          = "The Payline's Mobile SDK allows a merchant's mobile application to use Payline services to realize an online payment or manage the wallet."

  s.description      = <<-DESC
  This integration allows the process with a WebView, a native integration of the iOS and Android and a compatibility with the 3DS v2. The use of Payline Widget allows each merchant to integrate the payment functions directly into their website without any break with their purchase flow, while having the constraints PCI-DSS SAQ A. The payment form can be included in a global form containing specific fields (address of deliveries, vouchers, etc ...). In a single integration, the merchant benefits by simple setting of:
  - Several payment methods available with the Payline widget (3DSecure, Paypal, AmazonPay, gift card, ...);
  - Innovative features available with the Payline Widget (one-click payment, alternative payment method, multi-card payment, etc.)
                       DESC

  s.homepage         = 'https://github.com/PaylineByMonext/payline-ios-sdk'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.author           = { 'Payline' => 'support@payline.com' }
  s.source           = { :git => 'https://github.com/PaylineByMonext/payline-ios-sdk.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'PaylineSDK/Classes/**/*'

  s.resources = "PaylineSDK/Assets/*.xcassets"

  s.swift_version = '5.1'

  # s.public_header_files = 'Pod/Classes/**/*.h'

end
