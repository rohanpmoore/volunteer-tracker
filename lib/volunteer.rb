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
end
