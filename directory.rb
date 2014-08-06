require 'csv'

@students = []

def interactive_menu
	loop do
		try_load_students
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
		puts "1. Input students"
		puts "2. Show students"
		puts "3. Save students"
		puts "4. Load students"
		puts "9. Exit"
		print "> "
end

def show_students
	print_header
	print_students_list
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
	@name = STDIN.gets.chomp
	@cohort = STDIN.gets.chomp ||= :august # ensures default value of :august
	@hobby = STDIN.gets.chomp
end

def print_header
	puts "The students of the August cohort at Makers Academy:"
end

def load_students(filename = 'students.csv')
	CSV.foreach(filename) { |line| add_students(line[0], line[1], line[2]) }
	puts "Students loaded from file!"
end

def save_students
	file = File.open("students.csv", "w")
	@students.each do |student|
		student_data = [student[:name], student[:cohort], student[:hobby]]
		csv_line = student_data.join(",")
		file.puts csv_line
	end
	puts "Students saved!"
	file.close
end

def add_students(name, cohort, hobby)
	@students << {:name => name, :cohort => cohort.to_sym, :hobby => hobby}
end

def print_students_list
	@students.each_with_index { |student, index| puts "#{index+1} #{student[:name]} (#{student[:cohort]} cohort), hobby: #{student[:hobby]}"}
end

def try_load_students
	filename = ARGV.first
	return if filename.nil?
	if File.exists?(filename)
		load_students(filename)
		puts "Loaded #{@students.length} from #{filename}"
	else
		puts "Sorry, #{filename} doesn't exist."
		exit
	end
end

def print_footer
	puts "Overall, we have #{@students.length} great students."
end

interactive_menu