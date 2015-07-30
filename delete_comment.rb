class Gsub
	def gsub_comment(path)
	  file = File.open(path, "r")
	  buffer = file.read
	  buffer.gsub!(/(=begin)|(=end)/, "")
	end

	def save_item(path, buffer)
	  f = File.open(path, "w")
	  f.write(buffer)
	  f.close
	end
end

file_name = gets.chomp.to_s
path = File.expand_path(file_name)

gsub_item = Gsub.new
buffer_item = gsub_item.gsub_comment(path)

gsub_item.save_item(path, buffer_item)



