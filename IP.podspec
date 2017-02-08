Pod::Spec.new do |s|
  s.name         = "IP"
  s.version      = "0.0.1"
  s.summary      = "IPv4/IPv6 address, such as host, interface, routing table, default gateway."
  s.homepage     = "https://github.com/yusuga/IP"
  s.screenshots  = "https://github.com/yusuga/IP/blob/master/.github/routing-table.png?raw=true"
  s.license      = "MIT"
  s.author             = "Yu Sugawara"
  s.social_media_url   = "https://twitter.com/yusuga_"
  
  s.ios.deployment_target = "9.0"
      
  s.source       = { :git => "https://github.com/yusuga/IP.git", :tag => s.version.to_s }  
  s.source_files  = "IP/*.{swift}"
  s.requires_arc = true
  
  s.preserve_paths = "IP/libinfo/*", "IP/libnetwork/*"
  s.libraries   = "info", "network"
  s.pod_target_xcconfig = { 'SWIFT_INCLUDE_PATHS' => '$(PODS_ROOT)/IP/IP/libinfo $(PODS_ROOT)/IP/IP/libnetwork' }
end
