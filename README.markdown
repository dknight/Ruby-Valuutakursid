Takes data from Estonian bank and gets the freshest money rates or archieve data.

#Usage

> Valuutakursid.new(string date)

R = Valuutakursid.new('27.10.2009')

rates = R.get_data

puts rates

puts rates['EUR']
