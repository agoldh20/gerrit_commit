require 'find'

class CommitMessage
  attr_accessor :jira_gets, :true_id, :tss, :tse, :type_gets, :jira_info, :drive_type_string, :filtered_results, :updated_status, :location

  def inputs
    puts "Enter jira ticket number"
    @jira_gets = gets.chomp
    @jira_info = "HADLG-#{jira_gets.gsub(/[^0-9]/, "")}"
    puts "Enter True HT Drive ID"
    @true_id = gets.chomp
    puts "Enter Time Stamp Start"
    @tss = gets.chomp
    puts "Enter Time Stamp End"
    @tse = gets.chomp
    puts "Was this a 2D, 3D, or 2D3D drive?"
    @type_gets = gets.chomp.upcase
    puts "Was this an Updated Drive? Yes or No"
    updated_gets = gets.chomp.downcase
    @updated_status = true if updated_gets == "yes"
    puts "Where is this Drive Located?"
    @location = gets.chomp
  end

  def drive_type
    if @type_gets.include?("2") && @type_gets.include?("3")
      @drive_type_string = "2D_3D"
    elsif @type_gets.include?("2")
      @drive_type_string = "2D"
    else
      @drive_type_string = "3D"
    end
    @drive_type_string << "_Updated" if @updated_status == true
  end

  def file_results
    text_file_paths = []
    @filtered_results = []

    Find.find('/home/goldwate/Desktop/Signs_Drive/') do |path|
      text_file_paths << path if path =~ /.*\.txt$/
    end

    text_file_paths.select {|file_path| @filtered_results << file_path if file_path.include?("#{@true_id}_TSS#{@tss}_TSE#{@tse}")}
  end

  def happy_message
    drive_type
    info_file = @filtered_results[0]

    file = File.open("#{info_file}")

    all_file_lines = file.read.split("\n")
    gerrit_commit_message = ["#{@jira_info} #{@drive_type_string}_Sign_Faces", "#{@true_id}_TSS#{@tss}_TSE#{@tse}", ""]


    all_file_lines.select {|line| gerrit_commit_message << line if line.include?("Sign")}

    total_sign = 0

    gerrit_commit_message.slice(3..5).each do |number|
      sign_count = number.gsub(/[^0-9]/, "").to_i
      total_sign += sign_count
    end

    gerrit_commit_message << "totalSign: #{total_sign}"
    gerrit_commit_message << ""

    all_file_lines.select {|line| gerrit_commit_message << "#{line}hr" if line.include?("Time")}

    if @updated_status == true
      gerrit_commit_message.insert(3, "Note: This is the Update Version for #{@location} 2x2000 Drive\nAs per finalized labeling instructions")
      gerrit_commit_message.insert(4, "")
    else
      gerrit_commit_message.insert(3, "Location: #{location}")
      gerrit_commit_message.insert(4, "")
    end

    puts "=============== GERRIT COMMIT MESSAGE ==============="
    puts gerrit_commit_message
    puts "============= END GERRIT COMMIT MESSAGE ============="
  end

  def sad_message
    puts "More than one possible relevant text find found related to this drive."
    puts "=========== TEXT FILES FOUND =========="
    @filtered_results.each_with_index do |result, index|
      puts "#{index + 1}: #{result}"
    end
    puts "============= END TEXT FILES FOUND ============="
    puts "Which file would you like to use?"
    @filtered_results[0] = @filtered_results[gets.chomp.to_i - 1]
    happy_message
  end

  def compile
    inputs
    file_results

    if @filtered_results.count == 1
      happy_message
    else
      sad_message
    end
  end

end

compiled_commit_message = CommitMessage.new
compiled_commit_message.compile
