Dir.chdir("#{ARGV[0]}")
puts Dir.pwd
files = `ls`
file = files.split("\n")
puts file
puts "=================================="
sub = Array.new()
parse = Array.new()
$lines=0
$c=0
$i=0
inblock = false
infunc = false
type = false
inboth = false

#looping through all files
for i in file
	Dir.chdir("#{ARGV[0]}")
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
			if line.start_with?("int") || line.start_with?("double") || line.start_with?("void") ||
				 line.start_with?("char") || line.start_with?("float")
				 type = true
			end
			red_1 = line.split("(")
			if type == true
				if red_1[0]!= "int" && red_1[0]!= "double" && red_1[0]!= "void" &&
					red_1[0]!= "char" && red_1[0]!= "float"
					infunc = true
					type = false
					puts line
				end
			end
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
			if infunc
				lines +=1
			end

			if inblock
				puts line
				line.each_char do |c|
					if c.eql?("{") && line.start_with?("{") == false
						$i+=1
					elsif c.eql?("}")	 	 
						$i-=1
					end
				end
				if $i==0
					inblock = false
					if $c > 2
						sub << "too complicated if constructions "
						sub << "super duper"
					end
					puts "BLOCK ENDED"
					$c=0
				end
			end
			#puts $i
		end
	end
	puts "File : " + i + "  ENDED EDITING  "
	if File.exist?("#{ARGV[0]}/results") == false
		Dir.mkdir("/#{ARGV[0]}/results")
	end
	Dir.chdir("#{ARGV[0]}/results")
	File.open("(#{i})results.txt","w") do |line|
		sub.each do |el|
			line << el + "\n"
		end
	end

	parse.clear
	sub.clear
end 
#p parse

