require 'csv'

@students = []

def interactive_menu
	loop do
		print_menu
		process(STDIN.gets.chomp)
	end
end

def process(selection)
	case selection
	when "1" then input_students
	when "2" then show_students
	when "3" then save_students
	when "4" then load_students
	when "9" then exit 
	else
		puts "I don't know what you meant, try again."
	end
end

def print_menu
		puts 	"1. Input students"
		puts 	"2. Show students"
		puts 	"3. Save students"
		puts 	"4. Load students"
		puts 	"9. Exit"
		print "> "
end

def show_students
	puts "Sort students by name, cohort, or hobby?"
	puts "> "
	sort = STDIN.gets.chomp
	print_header
	print_students_list(sort)
	print_footer
end

def input_students
	puts "Please enter the names, cohort and hobby of the students."
	puts "To finish, just make a blank entry."
	get_input
	until @name.empty? do
		add_students(@name, @cohort, @hobby)
		puts "Now we have #{@students.length} student#{"s" if @students.length >= 2}"
		get_input
	end
end

def get_input
	@name 	= STDIN.gets.chomp
	@cohort = STDIN.gets.chomp ||= :august # ensures default value of :august
	@hobby 	= STDIN.gets.chomp
end

def print_header
	puts "The students at Makers Academy:"
end

def load_students
	puts "Type the name of the file you wish to import from."
	print "> "
	filename = STDIN.gets.chomp
	CSV.foreach(filename) { |line| add_students(line[0], line[1], line[2]) }
	puts "Students loaded from file!"
end

def save_students
	puts 	"Type the name of the file you wish to save to."
	print "> "
	filename 	= STDIN.gets.chomp
	CSV.open(filename, "w") do |csv|
		@students.each { |student| csv << student.values }
	end
end

def add_students(name, cohort, hobby)
	@students << {:name => name, :cohort => cohort.to_sym, :hobby => hobby}
end

def print_students_list(sort)
	@students.sort_by! do |student|
		student[sort.to_sym]
	end
	@students.each_with_index { |student, index| puts "#{index+1} #{student[:name]} (#{student[:cohort]} cohort), hobby: #{student[:hobby]}"}
end

def try_load_students
	filename = ARGV.first
	return if filename.nil? # End the method immediately if user didn't specify a filename at runtime
	if File.exists?(filename)
		CSV.foreach(filename) { |line| add_students(line[0], line[1], line[2]) }
		puts "Loaded #{@students.length} from #{filename}"
	else
		puts "Sorry, #{filename} doesn't exist."
		exit
	end
end

def print_footer
	puts "Overall, we have #{@students.length} great students."
end

try_load_students
interactive_menu