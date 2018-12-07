require("sinatra")
require("sinatra/reloader")
also_reload("lib/**/*.rb")
require("./lib/project")
require("./lib/volunteer")
require("pg")

DB = PG.connect({:dbname => "volunteer_tracker_test"})

get('/') do
  @projects = Project.all
  erb :index
end

post('/project') do
  title = params["title"]
  project = Project.new({:title => title})
  project.save
  redirect '/'
end
