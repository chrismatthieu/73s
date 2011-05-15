require 'simple_forum'

ForumsController.view_paths = [File.join(RAILS_ROOT, 'app/views'),
                               File.join(directory, 'lib/views')]
TopicsController.view_paths = [File.join(RAILS_ROOT, 'app/views'),
                              File.join(directory, 'lib/views')]
PostsController.view_paths = [File.join(RAILS_ROOT, 'app/views'),
                              File.join(directory, 'lib/views')]
