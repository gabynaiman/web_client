# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "web_client/version"

Gem::Specification.new do |s|
  s.name         = 'web_client'
  s.version      = WebClient::VERSION
  s.authors      = ['Gabriel Naiman']
  s.email        = ['gabynaiman@gmail.com']
  s.homepage     = 'https://github.com/gabynaiman/web_client'
  s.summary      = %q{Net::HTTP wrapper easy to use}
  s.description  = %q{Net::HTTP wrapper easy to use}
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'
end
