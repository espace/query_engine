ActionController::Routing::Routes.draw do |map|
  map.connect 'queries/track.:format',:controller=>"queries_engine",:action=>"track"
  map.connect 'queries/track_all.:format',:controller=>"queries_engine",:action=>"get_all_time_entries_from_begining_of_month_till_now"
  map.connect 'queries/average_logged_hours_till_now.:format',:controller=>"queries_engine",:action=>"average_logged_hours_till_now"
  map.connect 'queries/get_activities.:format',:controller=>"queries_engine",:action=>"get_all_activities"
  map.connect 'queries/get_charts_data.:format',:controller=>"queries_engine",:action=>"get_charts_data"
end