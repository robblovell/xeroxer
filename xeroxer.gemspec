# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{xeroxer}
  s.version = "0.5.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Robb Lovell"]
  s.date = %q{2013-06-20}
  s.description = %q{Xeroxer copies files from one url to another.  Three url types are supported: S3, http(s), and files}
  s.email = %q{robblovell@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rbenv-version",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "lib/xeroxer.rb",
    "lib/xeroxer/File.rb",
    "lib/xeroxer/HTTP.rb",
    "lib/xeroxer/S3.rb",
    "lib/xeroxer/example_init.rb",
    "lib/xeroxer/example_rails_xeroxer_config.yml",
    "lib/xeroxer/example_xeroxer_config.yml",
    "lib/xeroxer/exceptions.rb",
    "lib/xeroxer/resource.rb",
    "lib/xeroxer/xeroxer.rb",
    "lib/xeroxer/xeroxer_config.rb",
    "spec/rcov.opts",
    "spec/resources/.gitkeep",
    "spec/spec.opts",
    "spec/spec_helper.rb",
    "spec/xeroxer_config_spec.rb",
    "spec/xeroxer_perm_spec.rb",
    "spec/xeroxer_spec_file.rb",
    "xeroxer.gemspec"
  ]
  s.homepage = %q{http://github.com/robblovell/xeroxer}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Xeroxer copies files from one url to another.  Three url types are supported: S3, http(s), and files}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, ["= 1.5.10"])
      s.add_runtime_dependency(%q<aws-sdk>, ["~> 1.8.5"])
      s.add_development_dependency(%q<bundler>, ["> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<rspec>, ["~> 2.11.0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<awesome_print>, [">= 0"])
    else
      s.add_dependency(%q<nokogiri>, ["= 1.5.10"])
      s.add_dependency(%q<aws-sdk>, ["~> 1.8.5"])
      s.add_dependency(%q<bundler>, ["> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<rspec>, ["~> 2.11.0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<awesome_print>, [">= 0"])
    end
  else
    s.add_dependency(%q<nokogiri>, ["= 1.5.10"])
    s.add_dependency(%q<aws-sdk>, ["~> 1.8.5"])
    s.add_dependency(%q<bundler>, ["> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<rspec>, ["~> 2.11.0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<awesome_print>, [">= 0"])
  end
end

