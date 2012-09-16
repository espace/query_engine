class QueriesEngineController < ApplicationController
  skip_before_filter :check_if_login_required
  before_filter :authenticate
  
  def authenticate
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      md5_of_password = Digest::MD5.hexdigest(password)
      username == 'etime' && md5_of_password == '708590f9a2db25b9d2e58732cc9ea1d0'
     end
  end

  def track
    params[:date] ||=Date.yesterday
    user_id=User.find_by_sql("select id from users where login=#{params[:login]};")[0].id
    @result=TimeEntry.find(:all,:select=>"sum(time_entries.hours) as hours,
                                          enumerations.name,
                                          enumerations.id",
                                :joins=>"INNER JOIN enumerations ON time_entries.activity_id=enumerations.id",
                                :conditions=>"enumerations.type='TimeEntryActivity' and time_entries.user_id=#{user_id} and time_entries.spent_on='#{params[:date]}'",
                                :group=>"enumerations.name")                                  
    respond_to do |format|
      format.xml  { render :xml => @result }
    end
  end
  
  def get_all_time_entries_from_begining_of_month_till_now
    user_id=User.find_by_sql("select id from users where login=#{params[:login]};")[0].id
    @result=TimeEntry.find(:all,:select=>"sum(time_entries.hours) as hours,
                                          time_entries.spent_on,
                                          enumerations.name,
                                          enumerations.id",
                                :joins=>"INNER JOIN enumerations ON time_entries.activity_id=enumerations.id",
                                :conditions=>"enumerations.type='TimeEntryActivity' and time_entries.user_id=#{user_id} and time_entries.spent_on between '#{Date.yesterday.beginning_of_month}' and '#{Date.yesterday}'",
                                :group=>"enumerations.name,time_entries.spent_on")                                  
    respond_to do |format|
      format.xml  { render :xml => @result }
    end
  end
  
  def average_logged_hours_till_now
    user_id=User.find_by_sql("select id from users where login=#{params[:login]};")[0].id
    @result=TimeEntry.find(:all,:select=>"Avg(total) as Average",
                                :from=>"(select sum(hours) as total from time_entries",
                                :conditions=>"user_id=#{user_id} and spent_on between '#{Date.today.beginning_of_month}' and '#{Date.today}'",
                                :group=>"spent_on) as total_times")             
    respond_to do |format|
      format.xml  { render :xml => @result }
    end                                
  end
  
  def get_all_activities
    @result=TimeEntryActivity.find(:all,:select=>"id,name")             
    respond_to do |format|
      format.xml  { render :xml => @result }
    end       
  end
  
  def get_charts_data
    option=params[:option]
    date=params[:date].to_date
    if option.eql?('day')
      first_date=end_date=date
    elsif option.eql?('week')
      first_date=date.beginning_of_week- 1.days
      end_date=date.end_of_week- 1.days
    elsif option.eql?('month')
      first_date=date.beginning_of_month
      end_date=date.end_of_month
    end
    @result=TimeEntry.find(:all,:select=>"users.login,
                                          sum(time_entries.hours) as hours",
                                :joins=>"INNER JOIN users ON time_entries.user_id=users.id",
                                :conditions=>"time_entries.spent_on between '#{first_date}' and '#{end_date}'",
                                :group=>"users.id")                                  
    respond_to do |format|
      format.xml  { render :xml => @result }
    end
  end
end