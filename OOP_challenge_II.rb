require 'csv'

class Employee
  @@list_of_employees = {}

  attr_reader :last_name, :first_name, :base_salary
  attr_accessor :total_sales

  def initialize(data)
    @first_name = data['first']
    @last_name = data['last']
    @base_salary = data['base'].to_f / 12
    @total_sales = 0
  end

  def gross_salary
    @base_salary
  end

  def net_pay
    gross_salary * 0.70
  end

  class << self
    def top_salesperson
      @@list_of_employees.sort_by { |name, employee| employee.total_sales }.last
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
  def initialize(data)
    super
    @commision_percentage = data['percentage'].to_f
  end

  def gross_salary
    @base_salary + commission
  end

  def commission
    @total_sales * @commision_percentage
  end
end

class QuotaSalesPerson < Employee
  def initialize(data)
    super
    @bonus = data['bonus'].to_f
    @goal = data['goal'].to_f
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
  def initialize(data)
    super
    @bonus = data['bonus'].to_f
    @goal = data['goal'].to_f
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

CSV.foreach('employee.csv', headers: true) do |row|
  Employee.add_employee(Employee.new(row.to_hash))
end
CSV.foreach('commission_employee.csv', headers: true) do |row|
  Employee.add_employee(CommissionSalesPerson.new(row.to_hash))
end
CSV.foreach('quota_employee.csv', headers: true) do |row|
  Employee.add_employee(QuotaSalesPerson.new(row.to_hash))
end
CSV.foreach('owner.csv', headers: true) do |row|
  Employee.add_employee(Owner.new(row.to_hash))
end
Sale.all_sales('sales.csv')

Employee.list_of_employees.each do |last_name, employee|
  puts "***#{employee.first_name} #{employee.last_name}***"
  puts "Gross Salary: $#{sprintf("%.2f", employee.base_salary)}"
  puts "Commission: $#{sprintf("%.2f", employee.commission)}" if employee.respond_to?(:commission)
  puts "Net Pay: $#{sprintf("%.2f", employee.net_pay)}"
  puts "***\n\n"
end
