#!/usr/bin/env ruby

require 'rake'

if !File.exist?("#{ENV['HOME']}/Library/Application Support/Developer/Shared/Xcode/")
  mkdir "#{ENV['HOME']}/Library/Application Support/Developer/Shared/Xcode/"
end


task :install do
  ["File Templates", "Project Templates", "Specifications", "Target Templates"].each do |directory|
    cp_r directory, "#{ENV['HOME']}/Library/Application Support/Developer/Shared/Xcode/"
  end

if !File.exist?("#{ENV['HOME']}/Library/Developer/Shared/")
	mkdir "#{ENV['HOME']}/Library/Developer/Shared/"
end
cp_r "Documentation", "#{ENV['HOME']}/Library/Developer/Shared/"

end


task :default => [:install]