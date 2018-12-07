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
      id = project["id"].to_i
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

  def self.find(id)
    returned_project = DB.exec("SELECT * FROM projects WHERE id = #{id}")
    Project.all_basic(returned_project)[0]
  end

  def volunteers
    Volunteer.all_by_project(@id)
  end

  def update(attributes)
    @title = attributes[:title]
    DB.exec("UPDATE projects SET name = '#{@title}' WHERE id = #{@id}")
  end

  def delete
    DB.exec("DELETE FROM projects WHERE id = #{@id}")
    remove_volunteers = self.volunteers
    remove_volunteers.each do |volunteer|
      volunteer.add_project(0)
    end
  end

  def get_hours
    volunteer_list = self.volunteers
    output = 0
    volunteer_list.each do |volunteer|
      output += volunteer.hours
    end
    output
  end
end
