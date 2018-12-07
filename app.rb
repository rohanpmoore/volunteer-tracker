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

get('/project/:id') do
  @project = Project.find(params[:id])
  erb :project
end

get('/project/:id/edit') do
  @project = Project.find(params[:id])
  erb :project_edit
end

post('/project/:id/edit') do
  project = Project.find(params[:id])
  new_title = params[:title]
  project.update({:title => new_title})
  redirect "/project/#{params[:id]}"
end
