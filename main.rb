#!/usr/bin/ruby

class Project

    attr_reader :code_tags, :git_tags

    def initialize(filename, version_regex)
        # variables
        @filename = filename
        @version_regex = version_regex
        # upon init
        @code_tags = []
        @git_tags = []
        read_versions
        get_tags
    end

    def read_versions()
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
    end

    def get_tags()
        @git_tags = Dir.entries(".git/refs/tags/").select{ |i| i[@version_regex] }
    end

    def version_updated()
        for code_tag in @code_tags do
            puts "Checking for:" + code_tag
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

    if filename.empty?
        raise "No filename passed as env."
    end

    if regex.empty?
        regex = "/[v]\\d.\\d.\\d/"
    end

    project = Project.new(filename, eval(regex))
    if not project.version_updated
        raise "Version in code not updated."
    end
end