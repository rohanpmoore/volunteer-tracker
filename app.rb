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

post('/projects') do
  title = params["title"]
  project = Project.new({:title => title})
  project.save
  redirect '/'
end

get('/projects/:id') do
  @project = Project.find(params[:id])
  erb :project
end

get('/projects/:id/edit') do
  @project = Project.find(params[:id])
  erb :project_edit
end

patch('/projects/:id/edit') do
  project = Project.find(params[:id])
  new_title = params[:title]
  project.update({:title => new_title})
  redirect "/projects/#{params[:id]}"
end

delete('/projects/:id/edit') do
  project = Project.find(params[:id])
  project.delete
  redirect '/'
end
