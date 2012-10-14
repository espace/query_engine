# Include hook code here
require 'redmine'
require_dependency 'query_engine'

Redmine::Plugin.register :query_engine do
  name 'Redmine Query Engine'
  author 'Basayel Said and Yasmine Gaber'
  description 'It exports logged time on redmine to eTime'
  version '1.0.0'
end
