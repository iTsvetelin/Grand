output = `gcc #{ARGV[0]}`
print output
Dir.chdir("#{ARGV[1]}")
puts Dir.pwd
files = `ls`
file = files.split("\n")

for i in file
	ex = i.split(".")[0..1]
	if ex[1]!= "c"
		puts i + " : this file is not a C file"
	else
		puts "compiling " + i
		print `gcc #{i}`
		puts
	end
end 
