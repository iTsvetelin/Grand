Dir.chdir("#{ARGV[0]}")
puts Dir.pwd
files = `ls`
file = files.split("\n")
puts file
puts "=================================="
sub = Array.new()
parse = Array.new()
#complie = Array.new()
$lines=0
$liness=0
$c=0
$i=0
$f=0
$b_f=0
$count=0
inblock = false
infunc = false
inboth = false
$r_brackets =0
$w_brackets =0

#looping through all files
for i in file
	Dir.chdir("#{ARGV[0]}")
	print "editing file : " + i
	ex = i.split(".")[0..1]
	if ex[1]!= "c"
		puts " - this is not a C file"
		next
	else
		puts " - compiling "

		`gcc #{i} -W`
		
		File.open("#{i}").each do |line|
			parse << line.gsub(/\t/,"").gsub(/ /,"").gsub(/\n/,"")
		end

		parse.each do |line|
			$count += 1
			if line.length > 78
				sub << "Lines should not exceed 78 characters @line" + $count.to_s
			end
			red_1 = line.split("(")
			red_2 = line.split(")")
			red_3 = line.split("[")
			#p $i
			if line == ("{")
				$w_brackets+=1.0
			end
			if line.end_with?("{")
				if line != ("{")
					$r_brackets+=1.0
				end
			end
			if line.start_with?("int") || line.start_with?("double") || line.start_with?("void") ||
				 line.start_with?("char") || line.start_with?("float")
				if red_1[0]!= "intmain" && red_1[1]!= nil
					inblock = true
					infunc = true
					if red_2[1] == nil
						$i+=1
						$lines-=1
					end
				elsif red_1[0]!= "intmain" && red_1[1]== nil && red_3[1]== nil
					if line.downcase! != nil
						sub << "wrong variable naming @line" + $count.to_s
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
				#puts line
				if infunc
					if line!="" && line.start_with?("//") == false
						$lines+=1
						if $c==1
							$liness+=1
						end
					end
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
						sub << "too complicated if construction"
					end
					#puts "BLOCK ENDED"
					$c=0
					if infunc
						if $lines > 5
							$b_f+=1.0
						else
							$f+=1.0
						end
						if $lines - $liness == 1
							sub << "there is a function which can be replaced with trinary operator"
						end
						$lines=0
						$liness=0
					end
					infunc=false
				end
			end

			red_2.clear
			red_1.clear
			#puts $i
		end
	end


	if $f==0 && $b_f==0
		sub << "there are no functions"
	elsif $f>0 && $b_f==0
		sub <<  "all functions are  fine"
	elsif $f==0 && $b_f>0
		sub << "all functions are too big"
	elsif $f/$b_f <=1.0
		sub << "50% of the functions are too big"
	end
	if $w_brackets ==0
		sub << "all brackets are fine"
	elsif $r_brackets/$w_brackets <=1.0
		sub << "50% of the brackets are wrongly placed"
	end

	$f=0
	$b_f=0
	$w_brackets=0
	$r_brackets=0


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
	$count=0
	parse.clear
	sub.clear
end 

