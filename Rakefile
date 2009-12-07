#!/usr/bin/env ruby

require 'rake'

task :install do
  ["File Templates", "Project Templates", "Specifications", "Target Templates"].each do |directory|
    cp_r directory, "#{ENV['HOME']}/Library/Application Support/Developer/Shared/Xcode/"
  end
end

task :default => [:install]