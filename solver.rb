require 'hamster'

board = <<-BOARD
          OOOOOOO
          OOOOOOO
          OOOOOOO
          OOOOOOO
          OOOOOOO
          OOOOOOO
        BOARD

def level_array(level_string)
  level_string.split(/\n/).map { |row| row.strip.scan(/./) }
end

level = level_array(board)


puts 
