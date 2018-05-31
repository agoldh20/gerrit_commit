require 'find'

class CleanUp
  attr_accessor :filtered_results, :confirm

  def find_results
    text_file_paths = []
    @filtered_results = []

    Find.find(Dir.pwd) do |path|
      if path =~ /.*\.txt$/ || path =~ /.*\.csv$/
        text_file_paths << path
      end
    end

    text_file_paths.select do |file_path| 
      if file_path.include?("ErrorReport.csv") || file_path.include?("log.txt") 
        @filtered_results << file_path 
      end
    end
  end

  def results_found
    if @filtered_results.any?
      puts "======== Files Found ========"
      puts @filtered_results
      puts "======== Delete These Files? 'Yes' to Confirm, other to Cancel ========"
      @confirm = gets.chomp.downcase
    else
      puts "No Extra Files Found"
    end
  end

  def delete_files
    @filtered_results.each do |result|
      File.delete(result)
    end
  end

  def run
    find_results
    results_found
    delete_files if @confirm == "yes"
    puts "Clean Up complete, Have a good day!"
  end
end

program = CleanUp.new

program.run