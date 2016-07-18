require('sinatra')
require("sinatra/activerecord")
require('sinatra/reloader')
also_reload('lib/**/*.rb')
require('./lib/employee')
require('./lib/employee')


get('/') do
  @divisions = Division.all()
  erb(:index)
end

post('/divisions') do
  name = params.fetch('division_name')
  new_division = Division.new({:name => name})
  new_division.save()
  erb(:success)
end

get('/divisions/:id') do
  @division = Division.find(params.fetch('id').to_i())
  erb(:division)
end

get('/employees/:id') do
  @employee = Employee.find(params.fetch('id').to_i)
  erb(:employee)
end

post('/divisions/:id/new_employee') do
  first_name = params.fetch('new_employee_first_name')
  last_name = params.fetch('new_employee_last_name')
  @division = Division.find(params.fetch('id').to_i)
  new_employee = Employee.create({:first_name => first_name, :last_name => last_name, :division_id => @division.id(), :project_id => nil})
  erb(:new_employee_success)
end

patch('/divisions/:id/edit') do
  division_name = params.fetch('division_name')
  @division = Division.find(params.fetch('id').to_i)
  @division.update({:name => division_name})
  erb(:division)
end

delete('/divisions/:id/delete') do
  division = Division.find(params.fetch('id').to_i)
  division.delete()
  @divisions = Division.all()
  erb(:index)
end

patch('/employees/:id/edit') do
  @employee = Employee.find(params.fetch('id').to_i)
  first_name = params.fetch("employee_first_name") == ''? @employee.first_name : params.fetch("employee_first_name")
  last_name = params.fetch("employee_last_name") == ''? @employee.last_name : params.fetch("employee_last_name")
  @employee.update({:first_name => first_name, :last_name => last_name})
  erb(:employee)
end

delete('/employees/:id/delete') do
  @employee = Employee.find(params.fetch('id').to_i)
  @employee.delete()
  @division = @employee.division
  erb(:employee_delete_success)
end
