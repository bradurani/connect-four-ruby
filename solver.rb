require 'hamster'
require 'matrix'
require 'colorize'
require 'pry'

starting_board = <<-BOARD
                  OOOOOOO
                  OOOOOOO
                  RYRYOOO
                  YYYROOO
                  RRRROOO
                  YYRRROO
                BOARD

def flatten_tree_lazy(board_stream, piece)
  puts board_stream
  if(board_stream.any?)
    next_piece = piece == 'Y' ? 'R' : 'Y'
    next_tier = board_stream.flat_map { |b| possible_next_moves(b, piece)}
    board_stream.concat(Hamster.stream { flatten_tree_lazy(next_tier, next_piece)})
  else
    Hamster.list
  end
end

def possible_next_moves(board, piece)
  Hamster.list((0...board.first.length - 1).map do |n|
    add_piece_to_column(board, n, piece)
  end.compact)
end

def add_piece_to_column(board, n, piece)
  top_index = horizontal_highest_piece(board, n)
  return nil if top_index == 0
  board.set(top_index - 1, board[top_index - 1].set(n, piece))
end

def horizontal_highest_piece(board, n)
  board.map { |row| row[n] }.index { |char| char != 'O' } || board.length
end

#### Detect Winner ####

def board_score(board)
  horizontal_winner(board) || vertical_winner(board)
end

def horizontal_winner(board)
  board.reduce(nil) do |winner, row| 
    winner || vector_winner(row)
  end
end

def vertical_winner(board)
  (0...board.first.length).reduce(nil) do |winner, n| 
    winner || vector_winner(board.map { |row| row[n] })
  end
end

def vector_winner(row)
  winning_chunk = row.chunk(&:itself)
                     .detect do |tuple| 
                        tuple[0] != 'O' && tuple[1].length >= 4
                      end
  winning_chunk ? winning_chunk[0] : nil
end



#### SETUP ####

def board_matrix(level_string)
  Matrix.rows(level_string.split(/\n/).map { |row| row.strip.scan(/./) })
end

def board_list(matrix)
  Hamster::Vector.new(matrix.row_vectors.map do |row|
    Hamster::Vector.new(row)
  end)
end

#### PRETTY PRINT ####

def pp(board)
  board.reduce('') do |acc, row|
    acc + row + "\n"
  end
end

def color(piece)
  return piece
  case piece
  when 'O'; "●".white
  when 'R'; '●'.red
  when 'Y'; '●'.yellow
  else raise "Unknown char: #{piece}"
  end
end

def pp_list(board_list)
  board_list.reduce('') do |acc, board|
    puts 'new board'
    puts board
    acc + pp(board) + "\n"
  end
end

board = board_list(board_matrix(starting_board))
# tree = flatten_tree_lazy([board], 'R')
# first_50 = tree.take(2)
# puts(first_50)

p = possible_next_moves(board, 'R')
pp_list(p)
#puts(first_50)
#puts pp_list(first_50)
#puts pp_list(possible)
