# review

require "csv"

puts "PeakHours Initialized!"

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

hours = Array.new(24) {0}

contents.each do |line|
	time = line[:regdate]
   	hour = time.split(" ")
   	hour = hour[1].split(":")
   	hour = hour[0].split.join
   	hours[hour.to_i] += 1
end

hours.each_with_index {|registrants, hour| puts "There were #{registrants} registrations during hour #{hour}" }

