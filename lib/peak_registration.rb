require "csv"

# count, 
puts "PeakRegistration Initialized!"

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

registration = []

contents.each do |x|
	registration.push x[:regdate]
end

dates = []
times = []

registration.map! { |x| x.split(" ") } 

registration.each do |x|
	if registration.index(x) < 5176
		times.push x[1]
		dates.push x[0]
	end
end

times.map! { |x| x.rjust(2)[0..1].to_i }

x = 0
registration_count = []

while x < 25 do
	registration_count.push "#{times.count(x)} during hour #{x}"
	x = x + 1
end


puts registration_count
