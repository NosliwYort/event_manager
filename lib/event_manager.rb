require "csv"
require "sunlight"
require "erb"

Sunlight::Base.api_key = "e179a6973728c4dd3fb1204283aaccb5"

# ENSURE THAT ZIPCODES THAT ARE SHORT, LONG, OR MISSING ARE CLEANED UP
# OLD clean_zipcode METHOD
#def clean_zipcode(zipcode)
#	if zipcode.nil?
#		zipcode = "00000"
#	elsif zipcode.length < 5
#		zipcode = zipcode.rjust 5, "0"
#	elsif zipcode.length > 5
#		zipcode = zipcode[0..4]
#	else
#		zipcode
#	end
#end

# REFACTORED clean_zipcode METHOD
def clean_zipcode(zipcode)
	zipcode.to_s.rjust(5, "0")[0..4]
end

# ENSURE PHONE NUMBERS THAT ARE SHORT, LONG, OR IN A BAD FORMAT ARE CLEANED UP 
def clean_phone_numbers(homephone)
	homephone = homephone.to_s.gsub("("|")"|"-"|"."|" "|"/","")
	if homephone.length < 10 || homephone.length > 11
		homephone = "0000000000"
	elsif homephone[0] != 1
		homephone = "0000000000"
	elsif homephone.length = 11
		homephone.rjust(10)[1..10]
	else
		homephone
	end
end

# Encapsulates the way legislators are called for so that it would be easier to use an alternative to the Sunlight gem
def legislators_for_zipcode(zipcode)
	Sunlight::Legislator.all_in_zipcode(zipcode)
end

# Creates a directory for unique letters defined by index numbers, and writes the form to the file
def save_thank_you_letters(id,form_letter)
	Dir.mkdir("output") unless Dir.exist?("output")

	filename = "output/thanks_#{id}.html"

	File.open(filename, "w") do |file|
		file.puts form_letter
	end
end


puts "EventManager Initialized!"

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

contents.each do |row|
	id = row[0]
	first_name = row[:first_name]

	zipcode = clean_zipcode(row[:zipcode])
	
	legislators = legislators_for_zipcode(zipcode)

	form_letter = erb_template.result(binding)

	save_thank_you_letters(id,form_letter)
end
