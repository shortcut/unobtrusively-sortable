require 'fileutils'
namespace :unobtrusively_sortable do
  desc "Copies the required javascripts into public/javascripts"
  task :copy_javascripts do
    here = File.dirname(__FILE__)
    rails_root = File.join(here, '..', '..', '..', '..')
    javascript = File.join(here, '..', 'lib', 'unobtrusively_sortable.js')
    FileUtils.cp(javascript, File.join(rails_root, 'public', 'javascripts', 'unobtrusively_sortable.js'))
  end
end