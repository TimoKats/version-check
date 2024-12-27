#!/usr/bin/ruby

# Written by Timo Kats in Dec 2024
# Checks if the tags in code already exist in git tags.
# Can be used to prevent merging without updating the version first.

require 'uri'
require 'net/http'
require 'json'

class Project

    attr_reader :code_tags, :git_tags

    def initialize(filename, version_regex, tags_url)
        # variables
        @tags_url = tags_url.sub! 'github.com', 'api.github.com'
        @filename = filename
        @version_regex = version_regex
        # upon init
        @code_tags = []
        @git_tags = []
        get_code_tags
        get_git_tags
    end

    def get_code_tags()
        begin
            File.open(@filename, "r") do |f|
                f.each_line do |line|
                    @code_tags += line.scan(@version_regex)
                end
            end
        rescue Errno::ENOENT => e
            $stderr.puts "Error: #{e}"
            exit -1
        rescue TypeError => e
            $stderr.puts "Error: #{e} (Probably invalid VERSION_REGEX)"
            exit -1            
        end
        puts "Found the following tags in the code: " + @code_tags*", "
    end

    def get_git_tags()
        uri = URI(@tags_url) # "https://api.github.com/repos/TimoKats/pim/tags"
        res = Net::HTTP.get_response(uri)
        for item in JSON.parse(res.body) do
            @git_tags << item["name"]
        end
        puts "Found the following tags in git: " + @git_tags*", "
    end

    def version_updated()
        for code_tag in @code_tags do
            if not @git_tags.include? code_tag
                return true
            end
        end
        return false
    end

end

begin
    regex = ENV["VERSION_REGEX"] || ""
    filename = ENV["FILENAME"] || ""
    tags_url = ENV["TAGS_URL"] || ""

    if filename.empty? or tags_url.empty?
        raise "No filename or tags_url passed as env."
    end

    if regex.empty?
        regex = "/[v]\\d.\\d.\\d/"
    end

    project = Project.new(filename, eval(regex), tags_url)
    if not project.version_updated
        raise "Version in code not updated."
    else
        puts "Version in code is updated."
    end
end