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
        File.open(@filename, "r") do |f|
            f.each_line do |line|
                @code_tags += line.scan(@version_regex)
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
    filename = ENV["FILENAME"] || ""

    if filename.empty?
        raise "No filename passed as env."
    end

    project = Project.new(filename, eval(regex))
    if not project.version_updated
        raise "Version in code not updated."
    end
end