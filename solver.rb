require 'hamster-matrix'
require 'colorize'
require 'pry'

# @full_board = <<-BOARD
#                 RRYRRYR
#                 YRYYRRR
#                 RYRYRRR
#                 YYYRYYY
#                 RRYRYRY
#                 YYRRRYY
#               BOARD

@empty_board = <<-BOARD
                OOOOOOO
                OOOOOOO
                OOOOOOO
                OOOOOOO
                OOOOOOO
                OOOOOOO
              BOARD

# @red_won = <<-BOARD
#             OOOOOOO
#             OOOOOOO
#             ROOOOOO
#             ROOOOOO
#             ROYOOOO
#             ROYYOOO
#           BOARD


# @red_wins = <<-BOARD
#             OOOOOOO
#             OOOOOOO
#             OOOOOOO
#             ROOOOOO
#             ROYOOOO
#             ROYYOOO
#           BOARD

# red_in_2 = <<-BOARD
#             OOOOOOO
#             OOOOOOO
#             OOOOOOO
#             OOOOOOO
#             OOYOOOO
#             YOROROO
#           BOARD
# red_in_1 = <<-BOARD
#             OOOOOOO
#             OOOOOOO
#             OOOOOOO
#             OOOOOOO
#             OOYOOOO
#             YORRROO
#           BOARD

# def minimax(board, max_depth = 3, depth = 0, active_piece = 'R', moving_piece = 'R')
#   position_score = position_score(board, active_piece)
#   return position_score if position_score != 0
#   return 0 if depth > max_depth
#   positions = possible_next_boards(board, moving_piece).map do |board| 
#     minimax(board, max_depth, depth + 1, active_piece, opponent(moving_piece))
#   end
#   return 0 if positions.empty?
#   positions.max_by { |score| score.abs }
# end

# def position(board, score)
#   {
#     board: board,
#     score: score
#   }
# end

# def possible_next_boards(board, piece)
#   Hamster.interval(0, board.first.length - 1).map do |n|
#     add_piece_to_column(board, n, piece)
#   end.compact
# end

#### Detect Winner ####

# def opponent(piece)
#   piece == 'Y' ? 'R' : 'Y'
# end


# def position_score(board, piece)
#   case position_winner(board)
#   when piece; 1
#   when opponent(piece); -1
#   else 0;
#   end
# end

# def position_winner(board)
#   horizontal_winner(board) || vertical_winner(board)
# end

# def horizontal_winner(board)
#   board.reduce(nil) do |winner, row| 
#     winner || vector_winner(row)
#   end
# end

# def vertical_winner(board)
#   (0...board.first.length).reduce(nil) do |winner, n| 
#     winner || vector_winner(board.map { |row| row[n] })
#   end
# end

# def vector_winner(row)
#   winning_chunk = row.chunk(&:itself)
#                      .detect do |tuple| 
#                         tuple[0] != 'O' && tuple[1].length >= 4
#                       end
#   winning_chunk ? winning_chunk[0] : nil
# end

@state_manager = []

def add_piece_to_column(board, n, piece)
  top_index = horizontal_highest_piece(board, n)
  return nil if top_index == 0
  board.set(top_index - 1, n, piece)
end

def horizontal_highest_piece(board, n)
  board.row_vectors.map { |row| row[n] }.index { |char| char != 'O' } || board.row_vectors.length
end

def move(input, state)
  input = input[0]
  if(['1','2','3','4','5','6','7'].include?(input))
    board = add_piece_to_column(state[:board], input.to_i, state[:piece])
    state = {
      board: board,
      piece: state[:piece] == 'R' ? 'Y' : 'R'
    }
    @state_manager.push(state)
  else
    state = @state_manager.pop
  end
  state
end

#### SETUP ####

def load_board(level_string)
  Hamster::Matrix.rows(level_string.split(/\n/).map { |row| row.strip.scan(/./) })
end

#### PRETTY PRINT ####

def format_board(board)
  board.row_vectors.reduce('') do |acc, row|
    acc + row.map { |i| color(i) }.join + "\n"
  end
end

def color(piece)
  case piece
  when 'O'; "●".white
  when 'R'; '●'.red
  when 'Y'; '●'.yellow
  else raise "Unknown char: #{piece}"
  end
end

# def format_list(board_list)
#   board_list.reduce('') do |acc, board|
#     acc + format_board(board) + "\n\n"
#   end
# end

board = load_board(@empty_board)
state = {
  board: board,
  piece: 'R'
}
puts format_board(state[:board])
while(true)
  inp = gets
  state = move(inp, state)
  puts format_board(state[:board])
end
