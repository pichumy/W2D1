class Employee
  attr_reader :bonus, :salary 
  def initialize(name, title, salary, boss)
    @name = name 
    @title = title 
    @salary = salary
    @boss = add_boss(boss) 
  end  
  
  def add_boss(boss)
    boss.add_employee(self) unless boss.nil?  
    @boss = boss 
  end 
  
  def bonus(multiplier)
    @bonus = @salary * multiplier 
  end 
end 

class Manager < Employee 
  def initialize(name, title, salary, boss)
    super(name, title, salary, boss)
    @employees = []
  end 
  
  def add_employee(employee)
     @employees.push(employee)
  end 
  
  def bonus(multiplier)
    total = 0 
    @employees.each do |employee| 
      if employee.is_a?(Manager)
        total += employee.bonus(1)
      end 
      total += employee.salary
    end 
    @bonus = total * multiplier
  end 
  
end 

if __FILE__ == $0
  ned = Manager.new("Ned", "Founder", 1000000, nil)
  darren = Manager.new("Darren", "TA Manager", 78000, ned)
  shawna = Employee.new("Shawna", "TA", 12000, darren)
  david = Employee.new("David", "TA", 10000, darren)
  puts ned.bonus(5)
  puts darren.bonus(4)
  puts david.bonus(3)
end 