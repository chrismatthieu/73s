dir = File.dirname(__FILE__)
forum_stylesheet = dir + '/../../../public/stylesheets/simple_forum.css'

FileUtils.cp dir + '/public/stylesheets/simple_forum.css', forum_stylesheet unless File.exist?(forum_stylesheet)

puts IO.read(File.join(dir, 'README'))