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
$f=0
$b_f=0
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
		puts "---------------" + inblock.to_s
		parse.each do |line|
			if line.start_with?("int") || line.start_with?("double") || line.start_with?("void") ||
				 line.start_with?("char") || line.start_with?("float")
				 type = true
			end
			red_1 = line.split("(")
			red_2 = line.split(")")
			#p $i
			if type
				if red_1[0]!= "intmain" && red_1[1]!= nil
					inblock = true
					infunc = true
					$lines+=1
					if red_2[1] == nil
						$i+=1
					end
				end
			end
			if red_1[0] == "if"
				$c+=1
				if inblock == false
					inblock = true
				end
				if red_2[1] == nil
					$i+=1
				end
			end

			if inblock
				puts line
				if infunc
					$lines+=1
				end
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
					end
					puts "BLOCK ENDED"
					puts $lines
					$c=0
					if infunc
						if $lines > 5
							$b_f+=1.0
						else
							$f+=1.0
						end
						$lines=0
					end
					infunc=false
				end
			end
			type = false
			red_2.clear
			red_1.clear
			#puts $i
		end
	end
	if $f>0 || $b_f>0
		if $f/$b_f >=1
			sub << "50% of the functions are too big"
		end
	end
	$f=0
	$b_f=0

	puts "File : " + i + "  ENDED EDITING  "
	if File.exist?("#{ARGV[0]}/homew_results") == false
		Dir.mkdir("/#{ARGV[0]}/homew_results")
	end
	Dir.chdir("#{ARGV[0]}/homew_results")
	File.open("(#{i})result.txt","w") do |line|
		sub.each do |el|
			line << el + "\n"
		end
	end

	parse.clear
	sub.clear
end 
#p parse

