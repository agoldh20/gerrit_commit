require 'find'


def change_folder_name
  puts "Paste the file directory you'd like to change from ':' to '_'"
  dir_path = gets.chomp
  text_file_paths = []

  Find.find(dir_path) do |path|
    text_file_paths << path if path[50..51].match(/[HT]/)
  end

  text_file_paths.each do |file|
    File.rename(file, file.gsub("_", ":"))
  end
end

change_folder_name