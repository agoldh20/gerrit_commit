require 'find'
  
def app_counter
  file_paths = []

  Find.find("/Users/Adam/Desktop/Actualize/daily_problems/round_2") do |path|
    if path.match(/.*\.rb$/)
      file_paths << path
    end
  end

  p file_paths.count
end

app_counter