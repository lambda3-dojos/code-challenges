# -*- encoding : utf-8 -*-  

def map_repetitions
	puts "Load index file"
	all = File.read("output.txt").split("\n")
	puts "Create indexes map"
	map = all.each.with_index.inject({}) { |r, (code, index)| 
		r[code] ||= [] ; r[code] << index ; r }
end

class File
	def self.read_with_pagination
		chunk_size = 1024 ** 2
		total_pages = 5659 * 2
		i = 1
		total_lines = 0
		should_be = 7257600 + 1

		File.open("big-file-2.txt", "r") do |file|		
			last_line = nil
			while data = file.read(chunk_size)
				hashes = []

				data = last_line + data if last_line
				
				lines = data.split("\n")
				
				if data[-1] == "\n"
					last_line = nil
				else
					last_line = lines.last	
					lines.delete(last_line)
				end

				yield(lines)

				total_lines += lines.size
				#puts "Processing #{ "%.2f" % ((i.to_f / total_pages) * 100)}% | #{lines.size}"
				i += 1
			end

			if last_line
				yield(lines)
				total_lines += 1
			end
		end
		total_lines - should_be == 0
	end
end


def generate_hashes
	require 'digest'
	File.delete("output.txt") if File.exists?("output.txt")
	File.read_with_pagination do |lines|
		hashes = lines.map { |line| Digest::MD5.hexdigest(line) }
		File.open("output.txt", "a") { |f| f.puts hashes }
	end
end

start = Time.now
puts generate_hashes
unrepeated_lines = map_repetitions.
	map { |code, line_numbers| line_numbers[0]}.flatten

#File.open("good.txt", "w") { |f| f.puts unrepeated_lines}
#unrepeated_lines = File.read("good.txt").split("\n").map(&:to_i)

File.delete("final.txt") if File.exists?("final.txt")
File.open("final.txt", "a") do |f|
	chunck_start, chunck_end = 0, 0
	File.read_with_pagination do |lines|
		break if unrepeated_lines.empty?
		chunck_start = chunck_end
		chunck_end += lines.size
		if unrepeated_lines.first < chunck_end
			indexes = (chunck_start..chunck_end).to_a & unrepeated_lines[0, 650]
			f.puts indexes.map { |i| lines[i - chunck_start] }
			unrepeated_lines = unrepeated_lines[indexes.size..-1]
		end
	end
end

puts " #{ "%.2f" % (Time.now - start)} Segundos"
