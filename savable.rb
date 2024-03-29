module Savable
  def ask_new_or_continue_game
    print "Type 'n' for a new game or 'c' for continue a saved game: "
    answer = gets.chomp.downcase
    if answer == 'n'
      return
    elsif answer == 'c'
      continue_game
    else
      ask_new_or_continue_game
    end
  end

  def continue_game
    saves_count = Dir['./saves/*.marshal'].count { |file| File.file?(file) }

    suggestions = Dir['./saves/*.marshal'].unshift(0) #get rid of 0 index
    if saves_count > 1
      file_index_to_load = ask_file_index_to_load(suggestions)
      load_game(suggestions[file_index_to_load])
      return true
    elsif saves_count == 0
      puts "You don't have any saves yet. Starting a new game."
      return
    else
      load_game(suggestions[1])
      return true
    end
  end

  def ask_file_index_to_load(suggestions)
    puts "Which save do you want to use? Enter a number from the list below."
    suggestions.each_with_index do |file, index|
      puts "  #{index}. #{file[8..-9]}" unless index == 0
    end
    answer = gets.chomp.to_i
    unless (1...suggestions.length).include?(answer)
      ask_file_index_to_load(suggestions)
    end
    answer
  end

  def load_game(filename)
    file = File.open(filename, 'r') do |file|
      contents = file.read
      loaded_game = Marshal.load(contents)
      @loaded = true
      loaded_game.loaded = true
      loaded_game.play
      File.delete(file)
    end
  end

  def save_game
    Dir.mkdir('saves') unless Dir.exist?('saves')

    time = Time.now.strftime('%d-%b-%Y_%H-%M-%S')
    filename = "saves/#{time}.marshal"

    File.open(filename, 'w') do |file|
      file.puts Marshal.dump(self)
    end
    puts "Successfully saved. Type 'quit' or continue playing."
  end
end
