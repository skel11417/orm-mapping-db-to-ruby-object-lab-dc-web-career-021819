class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
    SQL
    results = DB[:conn].execute(sql)
    results.map {|result| Student.new_from_db(result)}
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = ?
    SQL
    results = DB[:conn].execute(sql, 9)
    results.map {|result| Student.new_from_db(result)}

  end

  def self.all_but_12th
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade IS NOT ?
    SQL
    results = DB[:conn].execute(sql, 12)
    results.map {|result| Student.new_from_db(result)}
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade < ?
    SQL
    results = DB[:conn].execute(sql, 12)
    results.map {|result| Student.new_from_db(result)}
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.name = (?)
      SQL

      row = DB[:conn].execute(sql, name)
      Student.new_from_db(row.first)
  end

  def self.first_X_students_in_grade_10(num_students)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = (?)
    SQL

    results = DB[:conn].execute(sql, 10).take(num_students)
    results.map {|result| Student.new_from_db(result)}
  end

  def self.first_student_in_grade_10
    first_X_students_in_grade_10(1)[0]
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = (?)
    SQL

    results = DB[:conn].execute(sql, grade)
    results.map {|result| Student.new_from_db(result)}
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
