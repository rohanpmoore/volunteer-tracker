require("sinatra")
require("sinatra/reloader")
also_reload("lib/**/*.rb")
require("./lib/project")
require("./lib/volunteer")
require("pg")

DB = PG.connect({:dbname => "volunteer_tracker_test"})

get('/') do
  @projects = Project.all
  @unassigned_volunteers = Volunteer.all_by_unassigned
  erb :index
end

get('/projects/:id') do
  @project = Project.find(params[:id].to_i)
  @volunteers = @project.volunteers
  erb :project
end

get('/projects/:id/edit') do
  @project = Project.find(params[:id].to_i)
  erb :project_edit
end

get('/volunteers/:id') do
  @volunteer = Volunteer.find(params[:id].to_i)
  @projects = Project.all
  erb :volunteer
end

post('/projects') do
  title = params["title"]
  project = Project.new({:title => title})
  project.save
  redirect '/'
end

post('/volunteers') do
  name = params["name"]
  volunteer = Volunteer.new({:name => name})
  volunteer.save
  redirect '/'
end

patch('/projects/:id/edit') do
  project = Project.find(params[:id].to_i)
  new_title = params[:title]
  project.update({:title => new_title})
  redirect "/projects/#{params[:id].to_i}"
end

patch('/volunteers/:id/add_project') do
  volunteer = Volunteer.find(params[:id].to_i)
  project_id = params[:project_id].to_i
  volunteer.add_project(project_id)
  redirect "/volunteers/#{params[:id].to_i}"
end

patch('/volunteers/:id/update') do
  id = params[:id].to_i
  volunteer = Volunteer.find(id)
  name = params[:name]
  volunteer.change_name(name)
  redirect "/volunteers/#{id}"
end

delete('/projects/:id/edit') do
  project = Project.find(params[:id])
  project.delete
  redirect '/'
end
