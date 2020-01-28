class Garden
  PLANT_PER_STUDENT = 2
  PLANTS = { 'R' => :radishes, 'C' => :clover, 'G' => :grass, 'V' => :violets }

  attr_reader :diagram

  def initialize(cups_diagram, students = nil)
    @diagram = cups_diagram
    @students = students || default[:students]
    @sorted_downcase_students = @students.map(&:downcase).sort
  end

  def default
    {students: %w( Alice Bob Charlie David Eve
     Fred Ginny Harriet Ileana Joseph Kincaid Larry)
     }
  end

  def method_missing method, *args, &block
    return super method, *args, &block unless @sorted_downcase_students.include? method.to_s
    self.class.send(:define_method, method) do
      retrieve_plants_for(method.to_s)
    end
    self.send method, *args, &block
  end

  def retrieve_plants_for(student)
    return unless @sorted_downcase_students.include? student

    start_index = @sorted_downcase_students.index(student) * PLANT_PER_STUDENT
    plants = n_plants_starting_at(PLANT_PER_STUDENT, start_index)
    plants_to_symbol(plants)
  end

  def n_plants_starting_at(plunts_number, starting_index)
    plants = []
    diagram_rows.each do |row|
      row[starting_index,plunts_number].split('').each do |plant|
        plants << plant
      end
    end
    plants
  end

  def plants_to_symbol(plants)
    plants.map { |plant| PLANTS[plant] }
  end

  def diagram_rows
    @diagram.split("\n")
  end
end

if $PROGRAM_NAME == __FILE__
  

  c = Garden.new("VVCG\nVVRC")

  p c.retrieve_plants_for('bob')
end