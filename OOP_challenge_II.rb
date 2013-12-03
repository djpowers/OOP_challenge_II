require 'csv'

class Employee

  @@list_of_employees = [] # array of employee objects
  attr_reader :last_name
  def initialize(first_name, last_name, base_salary)
    @first_name = first_name
    @last_name = last_name
    @base_salary = base_salary
  end

  def gross_salary
    @base_salary
  end

  def net_pay
    # calculates gross salary + bonuses - taxes
  end

  def gross_sales(sale)
    # Link between sales and employee
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
  end
end

class Sale
  @@employee_and_sales = {}
  def initialize(last_name, gross_sale_value)
    @last_name = last_name
    @gross_sale_value = gross_sale_value
  end

  def self.all_sales(file)
    CSV.foreach(file, headers: true) do |row|
      if @@employee_and_sales[row["last_name"]] == nil
        @@employee_and_sales[row["last_name"]] = row["gross_sale_value"].to_i # Sale objects instead of just prices?
      else
        @@employee_and_sales[row["last_name"]] += (row["gross_sale_value"].to_i)
      end
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