require 'erb'
require 'fileutils'

TemplateDir = File.join File.dirname(__FILE__), '..', 'templates'
TemplateExt = '.erb'

module Zoo
  def self.install_templates (type, binding)
    templates_search = File.join TemplateDir, type, '**', "*#{TemplateExt}"
    templates = Dir.glob(templates_search, File::FNM_DOTMATCH).select {|item| File.file? item}

    templates.each do |file|
      template = ERB.new File.read file

      local_file = file.sub File.join(TemplateDir, type), '.'

      local_file.sub! /__([A-Z,_]+)__/ do |var|
        var.gsub! /^__|__$/, ''
        var.downcase!
        eval(var, binding).to_s
      end

      local_file.sub! TemplateExt, ''

      if File.exists? local_file
        puts "#{local_file} already exists!".red
      else
        puts "Adding #{local_file}"

        FileUtils.mkdir_p File.dirname local_file
        new_file = File.new local_file, 'w'
        new_file.write template.result binding
        new_file.close
      end
    end

    dirs_search = File.join TemplateDir, type, '**', '**'
    directories = Dir.glob(dirs_search).select {|item| File.directory? item}
    # TODO: Dot-prefixed dirs?
    directories.each do |dir|
      local_dir = dir.sub File.join(TemplateDir, type), '.'
      unless File.directory? local_dir
        puts "Adding #{local_dir}/"
        FileUtils.mkdir_p local_dir
      end
    end
  end

  module Formatting
    def run_together
      gsub /\s+/, ''
    end

    def dasherize
      gsub /\s+/, '-'
    end

    def underscore
      gsub /\s+/, '_'
    end

    def camelize
      downcase.gsub(/\s+\w/) {|x| x.upcase.sub /\s+/, ''}
    end
  end

  String.send :include, Formatting
end
