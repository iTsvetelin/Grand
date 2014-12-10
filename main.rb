output = `gcc #{ARGV[0]}`
print output
Dir.chdir("#{ARGV[1]}")
puts Dir.pwd
files = `ls`
p files
file = files.split("\n")
puts file[]
