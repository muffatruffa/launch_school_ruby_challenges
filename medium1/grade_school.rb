class School
  Student = Struct.new(:name, :grade)

  def initialize
    @students = []
  end

  def add(name,grade)
    @students << Student.new(name, grade)
  end


  def to_h
    students = @students.group_by { |student| student.grade }
    students = students.map do |(grade, grouped_students)|
      [grade, grouped_students.map(&:name).sort]
    end
    students.sort { |a, b| a[0] <=> b[0] }.to_h
  end

  def grade(grade_target)
    to_h.fetch(grade_target, [])
  end
end