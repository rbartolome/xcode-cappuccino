#!/usr/bin/env ruby

require 'rake'

if !File.exist?("#{ENV['HOME']}/Library/Application Support/Developer/Shared/Xcode/")
  mkdir "#{ENV['HOME']}/Library/Application Support/Developer/Shared/Xcode/"
end

task :install do
  ["File Templates", "Project Templates", "Specifications", "Target Templates"].each do |directory|
    cp_r directory, "#{ENV['HOME']}/Library/Application Support/Developer/Shared/Xcode/"
  end
end

task :default => [:install]