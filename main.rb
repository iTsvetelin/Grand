output = `gcc #{ARGV[0]}`
print output
Dir.chdir("#{ARGV[1]}")
puts Dir.pwd
files = `ls`
file = files.split("\n")
puts file
puts "=================================="

#looping through all files
for i in file
	ex = i.split(".")[0..1]
	if ex[1]!= "c"
		puts i + " : this file is not a C file, or its name is wrong"
	else
		puts "compiling " + i
		c_result = `gcc #{i}`
		if c_result = ""
			puts "compilation succeed"
		else
			puts c_result
		end
	end
end 
