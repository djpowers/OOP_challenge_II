require 'csv'
require 'pry'

class Employee

  @@list_of_employees = {} # array of employee objects
  attr_reader :last_name, :first_name, :base_salary
  attr_accessor :total_sales
  def initialize(first_name, last_name, base_salary)
    @first_name = first_name
    @last_name = last_name
    @base_salary = base_salary / 12
    @total_sales = 0
  end

  def gross_salary
    @base_salary
  end

  def net_pay
    # calculates gross salary + bonuses - taxes
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
    @base_salary
  end

  def commission
    @total_sales * @commision_percentage
  end

end

class QuotaSalesPerson < Employee
  def initialize(first_name, last_name, base_salary, bonus, goal)
    super(first_name, last_name, base_salary)
    @bonus = bonus
    @goal = goal
  end

  def gross_salary
    if met_goal?
      @base_salary + @bonus
    else
      @base_salary
    end
  end

  def met_goal?
    @total_sales > @goal
  end

  def commission
    if met_goal?
      @bonus
    else
      0
    end
  end

end

class Owner < Employee
  def initialize(first_name, last_name, base_salary, bonus, goal)
    super(first_name, last_name, base_salary)
    @bonus = bonus
    @goal = goal
    @company_sales = 0
  end

  def gross_salary
    if met_goal?
      @base_salary + @bonus
    else
      @base_salary
    end
  end

  def company_sales
    @@list_of_employees.each do |last, employee|
      company_sales += employee.total_sales
    end
  end

  def met_goal?
    @company_sales > @goal
  end

  def commission
    if met_goal?
      @bonus
    else
      0
    end
  end
end

class Sale
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
end

# read employee csv to populate all employees
# populate designers
CSV.foreach('employee.csv', headers: true) do |row|
  Employee.add_employee(Employee.new(row["first"], row["last"], row["base"].to_f))
end
CSV.foreach('commission_employee.csv', headers: true) do |row|
  Employee.add_employee(CommissionSalesPerson.new(row["first"], row["last"], row["base"].to_f, row["percentage"].to_f))
end
CSV.foreach('quota_employee.csv', headers: true) do |row|
  Employee.add_employee(QuotaSalesPerson.new(row["first"], row["last"], row["base"].to_f, row["bonus"].to_f, row["goal"].to_f))
end
CSV.foreach('owner.csv', headers: true) do |row| # Is the owner an employee?
  Employee.add_employee(Owner.new(row["first"], row["last"], row["base"].to_f, row["bonus"].to_f, row["goal"].to_f))
end
Sale.all_sales('sales.csv')


Employee.list_of_employees.each do |last_name, employee|
  puts "#{employee.first_name} #{employee.last_name}"
  puts "Gross Salary: #{employee.base_salary}"
  # require 'pry'
  # binding.pry
  puts "Commission: #{employee.commission}" if employee.respond_to?(:commission)
  end

