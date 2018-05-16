require 'find'

puts "Enter jira ticket number"
jira_gets = gets.chomp
jira_info = "HADLG-#{jira_gets.gsub(/[^0-9]/, "")}"
puts "Enter True HT Drive ID"
true_id = gets.chomp
puts "Enter Time Stamp Start"
tss = gets.chomp
puts "Enter Time Stamp End"
tse = gets.chomp
puts "Was this a 2D, 3D, or 2D3D drive?"
type_gets = gets.chomp.upcase

if type_gets.include?("2") && type_gets.include?("3")
  drive_type = "2D_3D"
elsif type_gets.include?("2")
  drive_type = "2D"
else
  drive_type = "3D"
end

drive_type << "_Updated" if type_gets.include?("UPDATED")

text_file_paths = []
filtered_results = []

Find.find('/home/goldwate/Desktop/Signs_Drive/') do |path|
  text_file_paths << path if path =~ /.*\.txt$/
end

text_file_paths.select {|file_path| filtered_results << file_path if file_path.include?("#{true_id}_TSS#{tss}_TSE#{tse}")}

if filtered_results.count == 1

  info_file = filtered_results[0]

  file = File.open("#{info_file}")

  all_file_lines = file.read.split("\n")
  gerrit_commit_message = ["#{jira_info} #{drive_type}_Sign_Faces", "#{true_id}_TSS#{tss}_TSE#{tse}", ""]

  all_file_lines.select {|line| gerrit_commit_message << line if line.include?("Sign")}

  total_sign = 0

  gerrit_commit_message.slice(3..5).each do |number|
    sign_count = number.gsub(/[^0-9]/, "").to_i
    total_sign += sign_count
  end

  gerrit_commit_message << "totalSign: #{total_sign}"
  gerrit_commit_message << ""

  all_file_lines.select {|line| gerrit_commit_message << line if line.include?("Time")}

  puts "=============== GERRIT COMMIT MESSAGE ==============="
  puts gerrit_commit_message

else

  puts "More than one text find found related to this drive...Cannot compose Commit Message"
  puts "=============== TEXT FILES FOUND ==============="
  puts filtered_results

end
