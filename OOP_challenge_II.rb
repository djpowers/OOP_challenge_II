require 'csv'
require 'pry'

class Employee

  @@list_of_employees = {} # array of employee objects
  attr_reader :last_name
  attr_accessor :total_sales
  def initialize(first_name, last_name, base_salary)
    @first_name = first_name
    @last_name = last_name
    @base_salary = base_salary
    @total_sales = 0
  end

  def gross_salary
    @base_salary
  end

  def net_pay
    # calculates gross salary + bonuses - taxes
  end

  def gross_sales
    # Link between sales and employee
  end

  class << self
    def top_salesperson
      @@list_of_employees.sort_by{|name, employee| employee.total_sales }.last
    end

    def add_sale(sale)
      @@list_of_employees[sale.last_name].total_sales += sale.gross_sale_value
    end

    def add_employee(employee)
      @@list_of_employees[employee.last_name] = employee
    end

    def list_of_employees
      @@list_of_employees
    end
  end
end

class CommissionSalesPerson < Employee
  def initialize(first_name, last_name, base_salary, commision_percentage)
    super(first_name, last_name, base_salary)
    @commision_percentage = commision_percentage
  end

  def gross_salary
    @base_salary + commission
  end

  def commission
    @commision_percentage * gross_sales
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
    binding.pry
  end
end

class Sale
  @@employee_and_sales = {}
  attr_reader :last_name, :gross_sale_value

  def initialize(data)
    @last_name = data["last_name"]
    @gross_sale_value = data["gross_sale_value"].to_i
  end

  def self.all_sales(file)
    CSV.foreach(file, headers: true) do |row|
      Employee.add_sale(Sale.new(row.to_hash))
    end
  end

  def self.employee_and_sales
    @@employee_and_sales
  end

end

# read employee csv to populate all employees
# populate designers
CSV.foreach('employee.csv', headers: true) do |row|
  Employee.add_employee(Employee.new(row["first"], row["last"], row["base"].to_i))
end
CSV.foreach('commission_employee.csv', headers: true) do |row|
  Employee.add_employee(CommissionSalesPerson.new(row["first"], row["last"], row["base"].to_i, row["percentage"].to_f))
end
CSV.foreach('quota_employee.csv', headers: true) do |row|
  Employee.add_employee(QuotaSalesPerson.new(row["first"], row["last"], row["base"].to_i, row["bonus"].to_i, row["goal"].to_i))
end
CSV.foreach('owner.csv', headers: true) do |row| # Is the owner an employee?
  Employee.add_employee(Owner.new(row["first"], row["last"], row["base"].to_i, row["bonus"].to_i, row["goal"].to_i))
end
Sale.all_sales('sales.csv')

require 'pry'
binding.pry