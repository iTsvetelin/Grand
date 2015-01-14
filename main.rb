Dir.chdir("#{ARGV[0]}")
puts Dir.pwd
files = `ls`
file = files.split("\n")
puts file
puts "=================================="
sub = Array.new()
parse = Array.new()
$c=0
$i=0
inblock = false

#looping through all files
for i in file
	print "editing file : " + i + " "
	ex = i.split(".")[0..1]
	if ex[1]!= "c"
		puts " - this is not a C file"
		next
	else
		puts "compiling "
		`gcc #{i}`

		
		File.open("#{i}").each do |line|
			parse << line.gsub(/\t/,"").gsub(/ /,"").gsub(/\n/,"")
		end
		parse.each do |line|
			red_1 = line.split("(")
				if red_1[0] == "if"
					$c+=1
					if inblock == false
						inblock = true
					end
					red_2 = line.split(")")
					if red_2[1] == nil
						$i+=1
					end
				end
			if inblock
				puts line
				line.each_char do |c|
					if c.eql?("{") && line.start_with?("{") == false
						$i+=1
					elsif line.start_with?("else") || line.start_with?("elseif")
						$i+=1
					elsif c.eql?("}")	 	 
						$i-=1
					end
				end
				if $i==0
					inblock = false
					if $c > 2
						sub << "too complicated if constructions"
					end
					puts "BLOCK ENDED"
					$c=0
				end
			end
			#puts $i
		end
	end
	File.open("#{i}_results.txt","w") do |line|
		line << sub
	end
	puts "File : " + i + "  ENDED EDITING  "
	parse.clear
	sub.clear
end 
#p parse

