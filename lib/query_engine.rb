# QueryEngine
%w{ controllers }.each do |dir| 
  path = File.join(File.dirname(__FILE__), dir)  
  $LOAD_PATH << path 
  ActiveSupport::Dependencies.load_paths << path 
  ActiveSupport::Dependencies.load_once_paths.delete(path) 
end 