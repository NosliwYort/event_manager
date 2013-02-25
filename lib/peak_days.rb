#review

require "csv"

puts "PeakDays Initialized!"

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol


days = Array.new(7) {0}

contents.each do |line|
	date = line[:regdate]
	days_of_week = date.split(" ")
   	days_of_week = days_of_week[0].split.join
   	days_of_week = Date.strptime(days_of_week, "%m/%d/%y")
   	day = days_of_week.wday
   	days[day] = days[day] + 1
end

day_names = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

days.each_with_index { |registrants, day| puts "There were #{registrants} registrations on #{day_names[day]}" }

