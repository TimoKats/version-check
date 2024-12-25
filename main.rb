#!/usr/bin/ruby

class Project

    attr_reader :code_tags, :git_tags

    def initialize(files, version_regex)
        # variables
        @files = files
        @version_regex = version_regex
        # upon init
        @code_tags = []
        @git_tags = []
        read_versions
        get_tags
    end

    def read_versions()
            for file in @files do
                begin
                    File.open(file, "r") do |f|
                        f.each_line do |line|
                            @code_tags += line.scan(@version_regex)
                        end
                    end
                rescue Errno::ENOENT
                    puts "File not found: #{file}"
            end
        end
    end

    def get_tags()
        @git_tags = Dir.entries(".git/refs/tags/").select{ |i| i[@version_regex] }
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
    regex = ENV["VERSION_REGEX"]  || "/[v]\\d.\\d.\\d/"
    puts "Using regex: " + regex
    if ARGV.size == 0
        raise "No filenames passed as params."
    end
    project = Project.new(ARGV, eval(regex))
    if not project.version_updated
        raise "Version in code not updated."
    end
end