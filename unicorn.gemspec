# -*- encoding: binary -*-
ENV["VERSION"] ||= '5.1.0'
manifest = File.readlines('.manifest').map! { |x| x.chomp! }
# require 'olddoc'
# extend Olddoc::Gemspec
# name, summary, title = readme_metadata
name = "unicorn"
summary = "Rack HTTP server for fast clients and Unix"
title = "unicorn: Rack HTTP server for fast clients and Unix"
readme_description = "unicorn is an HTTP server for Rack applications designed to only serve\nfast clients on low-latency, high-bandwidth connections and take\nadvantage of features in Unix/Unix-like kernels.  Slow clients should\nonly be served by placing a reverse proxy capable of fully buffering\nboth the the request and response in between unicorn and slow clients."
extra_rdoc_files_manifest = ["FAQ",
  "README",
  "TUNING",
  "PHILOSOPHY",
  "HACKING",
  "DESIGN",
  "CONTRIBUTORS",
  "LICENSE",
  "SIGNALS",
  "KNOWN_ISSUES",
  "TODO",
  "lib/unicorn.rb",
  "lib/unicorn/configurator.rb",
  "lib/unicorn/http_server.rb",
  "lib/unicorn/preread_input.rb",
  "lib/unicorn/stream_input.rb",
  "lib/unicorn/tee_input.rb",
  "lib/unicorn/util.rb",
  "lib/unicorn/oob_gc.rb",
  "lib/unicorn/worker.rb",
  "ISSUES",
  "Sandbox",
  "Links",
  "Application_Timeouts"
]

# don't bother with tests that fork, not worth our time to get working
# with `gem check -t` ... (of course we care for them when testing with
# GNU make when they can run in parallel)
test_files = manifest.grep(%r{\Atest/unit/test_.*\.rb\z}).map do |f|
  File.readlines(f).grep(/\bfork\b/).empty? ? f : nil
end.compact

Gem::Specification.new do |s|
  s.name = %q{unicorn}
  s.version = ENV["VERSION"].dup
  s.authors = ["#{name} hackers"]
  s.summary = summary
  s.description = readme_description
  s.email = %q{unicorn-public@bogomips.org}
  s.executables = %w(unicorn unicorn_rails)
  s.extensions = %w(ext/unicorn_http/extconf.rb)
  s.extra_rdoc_files = extra_rdoc_files_manifest
  s.files = manifest
  s.homepage = "http://unicorn.bogomips.org/"
  s.test_files = test_files

  # technically we need ">= 1.9.3", too, but avoid the array here since
  # old rubygems versions (1.8.23.2 at least) do not support multiple
  # version requirements here.
  s.required_ruby_version = '< 3.0'

  # We do not have a hard dependency on rack, it's possible to load
  # things which respond to #call.  HTTP status lines in responses
  # won't have descriptive text, only the numeric status.
  s.add_development_dependency(%q<rack>)

  s.add_dependency(%q<kgio>, '~> 2.6')
  s.add_dependency(%q<raindrops>, '~> 0.7')

  s.add_development_dependency('test-unit', '~> 3.0')
  # s.add_development_dependency('olddoc', '~> 1.2')

  # Note: To avoid ambiguity, we intentionally avoid the SPDX-compatible
  # 'Ruby' here since Ruby 1.9.3 switched to BSD-2-Clause, but we
  # inherited our license from Mongrel when Ruby was at 1.8.
  # We cannot automatically switch licenses when Ruby changes.
  s.licenses = ['GPL-2.0+', 'Ruby-1.8']
end
