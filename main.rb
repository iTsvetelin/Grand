file_directory = File.expand_path(File.dirname(__FILE__))
value = Array.new()
File.open("#{file_directory}/properties.txt").each do |line|
	red = line.gsub(/ /,"").gsub(/\n/,"").split("=")
	value << red[1]
end
cc_variables = value[0]
$max_logical_operators = value[1].to_i
$max_if_count = value[2].to_i
$max_lines_func = value[3].to_i
$bracket_ratio = value[4].to_f
$funcion_ratio = value[5].to_f
$max_lines = value[6].to_i

Dir.chdir("#{ARGV[0]}")
puts Dir.pwd
files = `ls`
file = files.split("\n")
puts file
puts "=================================="
first_info = Array.new()
info = Array.new()
parse = Array.new()
$if_count=0
$lines=0
$liness=0
$brackets_count=0
$logical_operators_count =0
$normal_func=0
$big_func=0
$lines_count=0
inblock = false
infunc = false
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
			$lines_count += 1

			if line.length > 78
				info << "Lines should not exceed 78 characters @line" + $lines_count.to_s
			end

			red_1 = line.split("(")
			red_2 = line.split(")")
			red_3 = line.split("[")

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
						$brackets_count+=1
						$lines-=1
					end
				elsif red_1[0]!= "intmain" && red_1[1]== nil && red_3[1]== nil
					if line.downcase! != nil
						if cc_variables == "true"
							info << "wrong variable naming @line" + $lines_count.to_s
						end
					end
				end
			end

			if red_1[0] == "if"
				line.each_char do |char|
					if char.eql?("&") || char.eql?("|")
						$logical_operators_count+=1
					end
				end

				if $logical_operators_count/2 > $max_logical_operators
					info << "too complicated if condtion @line" + $lines_count.to_s
				end

				$logical_operators_count = 0
				$if_count+=1

				if inblock == false
					inblock = true
				end

				if red_2[1] == nil
					$brackets_count+=1
				end
			end

			if inblock
				if infunc
					if line!="" && line.start_with?("//") == false
						$lines+=1
						if $if_count>0
							$liness+=1
						end
					end
				end

				line.each_char do |c|
					if c.eql?("{") && line.start_with?("{") == false
						$brackets_count+=1
					elsif c.eql?("}")	 	 
						$brackets_count-=1
					end
				end

				if $brackets_count==0
					inblock = false
					if $if_count > $max_if_count
						info << "too many inbuilt if conditions"
					end
					#puts "BLOCK ENDED"
					$if_count=0

					if infunc
						if $lines > $max_lines_func
							$big_func+=1.0
						else
							$normal_func+=1.0
						end
						if $lines - $liness == 1
							info << "there is a function which can be replaced with a trinary operator"
						end
						$lines=0
						$liness=0
					end
					infunc=false
				end
			end
			red_3.clear
			red_2.clear
			red_1.clear
		end
	end


	if $normal_func==0 && $big_func==0
		info << "there are no functions"
	elsif $normal_func>0 && $big_func==0
		info <<  "all functions are  fine"
	elsif $normal_func==0 && $big_func>0
		info << "all functions are too big"
	elsif $normal_func/$big_func <=1.0						# <-=======================
		info << "50% of the functions are too big"
	end

	if $w_brackets ==0
		info << "all brackets are fine"
	elsif $r_brackets/$w_brackets <=1.0						# <-=======================
		info << "50% of the brackets are wrongly placed"
	end

	first_info << "source code is total of " + $lines_count.to_s + " lines"

	if $lines_count > $max_lines
		info << "the source code is too big"
	end

	$normal_func=0
	$big_func=0
	$w_brackets=0
	$r_brackets=0


	puts "File : " + i + "  ENDED EDITING  "
	if File.exist?("#{ARGV[0]}/homework_results") == false
		Dir.mkdir("/#{ARGV[0]}/homework_results")
	end
	Dir.chdir("#{ARGV[0]}/homework_results")
	File.open("(#{i})result.txt","w") do |line|
		info.each do |el|
			line << el + "\n"
		end
	end
	$lines_count=0
	parse.clear
	info.clear
	first_info.clear
end 

