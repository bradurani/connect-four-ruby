require 'hamster'
require 'matrix'
require 'pry'

board = <<-BOARD
          ROOOOOO
          BBBOORO
          RROBOOO
          BOOBOOO
          OOOBOOO
          OOOBOOO
        BOARD

def board_matrix(level_string)
  Matrix.rows(level_string.split(/\n/).map { |row| row.strip.scan(/./) })
end

def board_list(vectors)
  Hamster::Vector.new(vectors.map do |row|
    Hamster::Vector.new(row)
  end)
end

def boards(matrix)
  {
    horizontal: board_list(matrix.row_vectors),
    vertical: board_list(matrix.column_vectors) 
  }
end

def boards_score(boards)
  horizontal = board_score(boards[:horizontal])
  if(horizontal != 0)
    horizontal
  else
    board_score(boards[:vertical])
  end
end

def board_score(board)
  board.reduce(0) do |score, row|
    if(score != 0)
      score
    else
      row = row_score(row)
      if (row >= 4)
        1
      elsif (row <= -4)
        -1
      else
        0
      end
    end
  end
end

def row_score(row)
  row.reduce(0) do |score, position|
    if(score == 4 || score == -4)
      score
    elsif(position == 'R' && score >= 0)
      score + 1
    elsif(position == 'B' && score <= 0)
      score - 1
    else
      0
    end
  end
end

board = boards(board_matrix(board))
score = boards_score(board)

puts score
