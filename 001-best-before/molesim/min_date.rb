class IllegalArgumentError < Exception
end

def bisexto? year
	(year % 4 == 0 and not year % 100 == 0) or year % 400 == 0
end

def valid? (year, month, day)
	rules = { 1 => 31, 2 => bisexto?(year) ? 29 : 28, 3 => 31, 4 => 30, 5 => 31, 
		6 => 30, 7 => 31, 8 => 31, 9 => 30, 10 => 31, 11 => 30, 12 => 31 }
	rules[month] and rules[month] >= day
end

def min_date str
	year, month, day = arrange_values str.split('/').map(&:to_i).sort

	year += 2000 if year <= 99

	raise IllegalArgumentError if not valid?(year, month, day)
	
	Time.local year, month, day
end

def arrange_values values
	return values.rotate.rotate if values.last > 31
	values
end

###### Such another implementation

class Array
	def sum
		self.inject(0) { |r, i| r + i }
	end
end

class Hash
	def first_key_for_value(val)
		self.select{ |k, v| v == val}.map{ |k, v| k }.first
	end
end

MAX_VALUE = 9999999999

def min_date str
	values = str.split('/').map(&:to_i).map { |i| i == 0 ? 2000 : i}

	hip = values.map { values.rotate![0..1] + [values[2] + 2000] }.+([values]).
		select { |hipotese| hipotese.sum > 2000 }.map { |hipotese| hipotese.
		permutation.to_a }.flatten(1).inject({}) { |r, hipotese| 
		r[hipotese] = score_it(hipotese) ; r }
	
	raise IllegalArgumentError if hip.values.min == MAX_VALUE

	year, month, day = hip.first_key_for_value(hip.values.min)
	
	Time.local year, month, day
end

def score_it (hipotese)
	year, month, day = hipotese
	return MAX_VALUE if not valid? year, month, day
	(year * 10000) + (month * 100) + (day * 10)
end

##### Fernando Implementation ##########

def min_date str
	values = str.split('/').map(&:to_i).sort
	values = values.select{ |i| i > 31 } + values.select{ |i| i <= 31 }

	3.times do
		year = values.first + (values.first < 2000 ? 2000 : 0)
		[ values[1..2], values[1..2].rotate ].each { |(month, day)| 
			return Time.local year, month, day if valid?(year, month, day) }
		values.rotate!
	end

	raise IllegalArgumentError
end