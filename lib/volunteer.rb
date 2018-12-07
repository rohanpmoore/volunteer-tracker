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
end
