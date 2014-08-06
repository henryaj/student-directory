@students = []

def interactive_menu
	loop do
		# Attempt to load the list of students from file
		try_load_students
		# Print a menu of options for the user
		print_menu
		# Get input from the user and pass it to 'process' method which selects an option
		process(STDIN.gets.chomp)
	end
end

def process(selection)
	# Takes the option from the user and chooses the appropriate method
	case selection.downcase
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
	# Prints the menu
		puts "1. Input students"
		puts "2. Show students"
		puts "3. Save students"
		puts "4. Load students"
		puts "9. Exit"
		print "> "
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
	cohort = STDIN.gets.chomp.downcase.to_sym ||= :august
	hobby = STDIN.gets.chomp
	# while the name is not empty, repeat this code
	until name.empty? do
		
		# add the student hash to the array
		add_students(name, cohort, hobby)
		puts "Now we have #{@students.length} student#{"s" if @students.length >= 2}"
		# get another name from the user
		name = STDIN.gets.chomp
		cohort = STDIN.gets.chomp.downcase.to_sym ||= :august
		hobby = STDIN.gets.chomp
	end
end

def print_header
	# Prints header for the list of students
	puts "The students of the August cohort at Makers Academy:"
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
	# Loads a list of students from a csv file. If no filename is specified, defaults to students.csv
	File.open(filename, "r") do |file|
		file.readlines.each do |line|
		name, cohort, hobby = line.chomp.split(',') # Reads a line of the .csv file, removes the trailing line break, splits at the comma and saves each chunk into three variables
		add_students(name, cohort, hobby) # Passes those variables to the add_students method, which saves them to the array
		end
	end
	puts "Students loaded from file!"
end

def add_students(name, cohort, hobby)
	@students << {:name => name, :cohort => cohort.to_sym, :hobby => hobby}
	print "Student saved. "
end

def print_students_list
	@students.each_with_index { |student, index| puts "#{index+1} #{student[:name]} (#{student[:cohort]} cohort), hobby: #{student[:hobby]}"}
end

def try_load_students
	# Attempts to load a list of students from a command line argument, if one was given
	filename = ARGV.first #1st argument from cmd line
	return if filename.nil? #get out if no filename
	if File.exists?(filename) #if it exists
		load_students(filename)
		puts "Loaded #{@students.length} from #{filename}"
	else #if it doesn't exist
		puts "Sorry, #{filename} doesn't exist."
		exit
	end
end

def print_footer
	# Prints footer for use after the list of students
	puts "Overall, we have #{@students.length} great students."
end

interactive_menu