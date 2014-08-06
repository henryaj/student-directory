@students = []

def interactive_menu
	loop do
		# Attempt to load the list of students
		try_load_students
		# Print a menu of options for the user
		print_menu
		# Get input from the user and pass it to 'process' method which selects an option
		process(STDIN.gets.chomp)
	end
end

def process(selection)
	# Takes the option from the user and chooses the appropriate method
	case selection
	when "1"
		input_students
	when "2"
		show_students
	when "3"
		save_students
	when "4"
		load_students
	when "9"
		exit 
	else
		puts "I don't know what you meant, try again."
	end
end

def print_menu
	# Prints the menu
		puts "1. Input students"
		puts "2. Show students"
		puts "3. Save students"
		puts "4. Load students"
		puts "9. Exit"
end

def show_students
	# Shows the current list of students in memory
	print_header
	print_students_list
	print_footer
end

def input_students
	puts "Please enter the names, cohort and hobby of the students."
	puts "To finish, just make a blank entry."
	# get the first name
	name = STDIN.gets.chomp
	cohort = STDIN.gets.chomp.downcase.to_sym
	cohort = :august if cohort.empty?
	hobby = STDIN.gets.chomp
	# while the name is not empty, repeat this code
	while !name.empty? do
		
		# add the student hash to the array
		@students << {:name => name, :cohort => cohort, :hobby => hobby}
		puts "Now we have #{@students.length} student" if @students.length == 1
		puts "Now we have #{@students.length} students" if @students.length >= 2
		
		# get another name from the user
		name = STDIN.gets.chomp
		cohort = STDIN.gets.chomp.downcase.to_sym
		cohort = :august if cohort.empty?
		hobby = STDIN.gets.chomp
	
	end
end

def print_header
	# Prints header for the list of students
	puts "The students of the August cohort at Makers Academy:"
end

def print_students_list
	@students.each_with_index { |student, index| puts "#{index+1} #{student[:name]} (#{student[:cohort]} cohort) #{student[:hobby]}"}
end

def print_by_cohort
	@students.sort[:cohort]
	puts "Here are the students by cohort:"
	@students.each { |student| puts "#{student[:name]}, #{student[:cohort]}" }
end

def save_students
	# open the file for writing
	file = File.open("students.csv", "w")
	#iterate over students
	@students.each do |student|
		student_data = [student[:name], student[:cohort], student[:hobby]]
		csv_line = student_data.join(",")
		file.puts csv_line
	end
	puts "Students saved!"
	file.close
end

def load_students(filename = 'students.csv')
	file = File.open(filename, "r")
	file.readlines.each do |line|
		name, cohort, hobby = line.chomp.split(',')
		@students << {:name => name, :cohort => cohort.to_sym, :hobby => hobby}
		end
	file.close
	puts "Students loaded from file!"
end

def try_load_students
	filename = ARGV.first #1st argument from cmd line
	return if filename.nil? #get out if no filename
	if File.exists?(filename) #if it exists
		load_students(filename)
		puts "Loaded #{@students.length} from #{filename}"
	else #if it doesn't exist
		puts "Sorry #{filename} doesn't exist."
		exit
	end
end

def print_footer
	puts "Overall, we have #{@students.length} great students"
end

interactive_menu