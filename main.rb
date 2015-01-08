Dir.chdir("#{ARGV[0]}")
puts Dir.pwd
files = `ls`
file = files.split("\n")
puts file
puts "=================================="
parse = Array.new()
$i=0
inblock = false

#looping through all files
for i in file
	print "editing file : " + i + " "
	ex = i.split(".")[0..1]
	if ex[1]!= "c"
		puts " - this is not a C file"
	else
		puts "compiling "
		`gcc #{i}`

		
		File.open("#{i}").each do |line|
			#if line.gsub(/\t/,"").gsub(/ /,"").gsub(/\n/,"")== "{"
			#	puts "wrong syntax conventions"
			#end
			red_1 = line.gsub(/\t/,"").gsub(/ /,"").split("(")
			#parse << line.gsub(/\t/,"").gsub(/ /,"").gsub(/\n/,"")
			if inblock == false
				if red_1[0] == "if"
					inblock = true
					puts line
				end
			end
			if inblock
				line.each_char do |c|
					if c.eql?("{")
						$i+=1
					elsif c.eql?("}")	 	 
						$i-=1
					end
				end
				if $i==0
					inblock = false
					puts "BLOCK ENDED"
				end
			end
			#puts $i
		end
	end
end 
#print parse

