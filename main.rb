Dir.chdir("#{ARGV[0]}")
puts Dir.pwd
files = `ls`
file = files.split("\n")
puts file
puts "=================================="
parse = Array.new()

#looping through all files
for i in file
	print "editing file : " + i + " "
	ex = i.split(".")[0..1]
	if ex[1]!= "c"
		puts " : this file is not a C file, or its name is wrong"
	else
		puts "compiling "
		`gcc #{i}`

		
		File.open("#{i}").each do |line|
			if line.to_s == "{"
				puts "wrong syntax"
			end
			red_1 = line.gsub(/\t/,"").gsub(/ /,"").split("(")
			parse << line.gsub(/\t/,"").gsub(/ /,"")
			if red_1[0] == "if"
				puts line
			end
		end
	end
end 

puts parse
