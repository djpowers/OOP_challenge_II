require 'csv'

class Employee

  @@list_of_employees = [] # array of employee objects

  def initialize(first_name, last_name, base_salary)
    @first_name = first_name
    @last_name = last_name
    @base_salary = base_salary
  end

  def gross_salary
    # calculates gross salary
  end

  def net_pay
    # calculates gross salary + bonuses - taxes
  end

  def self.add_employee(employee)
    @@list_of_employees << employee
  end

  def self.list_of_employees
    @@list_of_employees
  end
end

class CommissionSalesPerson < Employee
  def initialize(first_name, last_name, base_salary, commision_percentage)
    super(first_name, last_name, base_salary)
    @commision_percentage = commision_percentage
  end
end

class QuotaSalesPerson < Employee
  def initialize(first_name, last_name, base_salary, bonus, goal)
    super(first_name, last_name, base_salary)
    @bonus = bonus
    @goal = goal
  end
end

class Owner < Employee
  def initialize(first_name, last_name, base_salary, bonus, goal)
    super(first_name, last_name, base_salary)
    @bonus = bonus
    @goal = goal
  end
end

class Sale
  def initialize(file)
    @file = file
  end

  def self.all_sales
    # returns list of sales loaded from CSV
  end
end

# read employee csv to populate all employees
# populate designers
CSV.foreach('employee.csv', headers: true) do |row|
  Employee.add_employee(Employee.new(row["first"], row["last"], row["base"]))
end
CSV.foreach('commission_employee.csv', headers: true) do |row|
  Employee.add_employee(CommissionSalesPerson.new(row["first"], row["last"], row["base"], row["percentage"]))
end
CSV.foreach('quota_employee.csv', headers: true) do |row|
  Employee.add_employee(QuotaSalesPerson.new(row["first"], row["last"], row["base"], row["bonus"], row["goal"]))
end
CSV.foreach('owner.csv', headers: true) do |row| # Is the owner an employee?
  Employee.add_employee(Owner.new(row["first"], row["last"], row["base"], row["bonus"], row["goal"]))
end
require 'pry'
binding.pry