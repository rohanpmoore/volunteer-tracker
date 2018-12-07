require 'pry'

class Volunteer
  attr_reader :name, :hours, :project_id, :id

  def initialize(attributes)
    @name = attributes[:name]
    @hours = attributes[:hours]
    @project_id = attributes[:project_id]
    @id = attributes[:id]
    if(!@hours)
      @hours = 0
    end
    if(!@project_id)
      @project_id = 0
    end
  end

  def ==(other_instance)
    @name == other_instance.name
  end

  def save
    result = DB.exec("INSERT INTO volunteers (name, hours, project_id) VALUES ('#{@name}', #{@hours}, #{@project_id}) RETURNING ID")
    @id = result.first["id"].to_i
  end

  def self.all_basic(volunteers)
    output_volunteers = []
    volunteers.each do |volunteer|
      id = volunteer["id"].to_i
      name = volunteer["name"]
      hours = volunteer["hours"].to_i
      project_id = volunteer["project_id"].to_i
      output_volunteers.push(Volunteer.new({:name => name, :hours => hours, :project_id => project_id, :id => id}))
    end
    output_volunteers
  end

  def self.all
    returned_volunteers = DB.exec("SELECT * FROM volunteers")
    Volunteer.all_basic(returned_volunteers)
  end

  def self.find(id)
    returned_volunteer = DB.exec("SELECT * FROM volunteers WHERE id = #{id}")
    Volunteer.all_basic(returned_volunteer)[0]
  end

  def self.all_by_project(project_id)
    returned_volunteers = DB.exec("SELECT * FROM volunteers WHERE project_id = #{project_id}")
    Volunteer.all_basic(returned_volunteers)
  end

  def self.all_by_unassigned
    returned_volunteers = DB.exec("SELECT * FROM volunteers WHERE project_id = 0")
    Volunteer.all_basic(returned_volunteers)
  end

  def add_project(project_id)
    @project_id = project_id
    DB.exec("UPDATE volunteers SET project_id = '#{@project_id}' WHERE id = #{@id}")
  end

  def change_name(name)
    @name = name
    DB.exec("UPDATE volunteers SET name = '#{@name}' WHERE id = #{@id}")
  end

  def add_hours(hours)
    @hours += hours
    DB.exec("UPDATE volunteers SET hours = '#{@hours}' WHERE id = #{@id}")
  end

  def self.all_by_hours(project_id)
    returned_volunteers = DB.exec("SELECT * FROM volunteers WHERE project_id = #{project_id} ORDER BY hours")
    Volunteer.all_basic(returned_volunteers)
  end

  def self.all_by_hours_inverse(project_id)
    returned_volunteers = DB.exec("SELECT * FROM volunteers WHERE project_id = #{project_id} ORDER BY hours DESC")
    Volunteer.all_basic(returned_volunteers)
  end

  def self.all_by_name(project_id)
    returned_volunteers = DB.exec("SELECT * FROM volunteers WHERE project_id = #{project_id} ORDER BY name")
    Volunteer.all_basic(returned_volunteers)
  end

  def delete
    DB.exec("DELETE FROM volunteers WHERE id = #{@id}")
  end
end
