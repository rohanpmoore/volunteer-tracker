require 'pry'

class Project
  attr_reader :title, :id

  def initialize(attributes)
    @title = attributes[:title]
    @id = attributes[:id]
  end

  def save
    result = DB.exec("INSERT INTO projects (name) VALUES ('#{@title}') RETURNING ID")
    @id = result.first["id"].to_i
  end

  def self.all_basic(projects)
    output_projects = []
    projects.each do |project|
      id = project["id"]
      title = project["name"]
      output_projects.push(Project.new({:title => title, :id => id}))
    end
    output_projects
  end

  def self.all
    returned_projects = DB.exec("SELECT * FROM projects")
    Project.all_basic(returned_projects)
  end

  def ==(other_instance)
    @title == other_instance.title
  end
end
