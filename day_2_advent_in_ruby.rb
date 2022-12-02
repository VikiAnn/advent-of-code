class RockPaperScissors
  MOVES = {
    'A' => :rock,
    'B' => :paper,
    'C' => :scissors,
    'X' => :rock,
    'Y' => :paper,
    'Z' => :scissors
  }
  
  OWNS = {
    rock: :scissors,
    scissors: :paper,
    paper: :rock
  }
  
  SCORES = {
    rock: 1,
    paper: 2,
    scissors: 3,
    lose: 0,
    draw: 3,
    win: 6
  }

  def initialize(round_input)
    @rounds = round_input.split("\n")
  end
  
  def score_rounds
    @score_rounds ||= @rounds.map do |round|
      theirs, mine = round.split.map { |m| MOVES[m] }
      outcome = round_outcome(mine, theirs)
      SCORES[mine] + SCORES[outcome]
    end
  end
  
  def round_outcome(my_move, their_move)
    if OWNS[my_move] == their_move
      :win
    elsif OWNS[their_move] == my_move
      :lose
    else
      :draw
    end
  end

  def total_score
    score_rounds.sum
  end
end


test_rounds = "A Y\nB X\nC Z"
test_game = RockPaperScissors.new(test_rounds)
round_scores = test_game.score_rounds

raise "Oops, that's not right" unless round_scores.sum == 15

rounds = File.read('elven_strategy_guide.txt')
game = RockPaperScissors.new(rounds)
puts "The original final score is #{game.total_score}"


class NewRockPaperScissors
  MOVES = {
    'A' => :rock,
    'B' => :paper,
    'C' => :scissors,
    'X' => :lose,
    'Y' => :draw,
    'Z' => :win
  }
  
  BEATEN_BY = {
    scissors: :rock,
    paper: :scissors,
    rock: :paper
  }
  
  SCORES = {
    rock: 1,
    paper: 2,
    scissors: 3,
    lose: 0,
    draw: 3,
    win: 6
  }
  
  def initialize(round_input)
    @rounds = round_input.split("\n")
  end
  
  def score_rounds
    @score_rounds ||= @rounds.map do |round|
      theirs, my_directive = round.split.map { |m| MOVES[m] }
      my_move = choose_move(my_directive, theirs)
      SCORES[my_move] + SCORES[my_directive]
    end
  end
  
  def choose_move(my_directive, their_move)
    case my_directive
    when :win
      BEATEN_BY[their_move]
    when :lose
      BEATEN_BY.invert[their_move]
    when :draw
      their_move
    end
  end
  
  def total_score
    score_rounds.sum
  end
end

test_rounds = "A Y\nB X\nC Z"
test_game = NewRockPaperScissors.new(test_rounds)
round_scores = test_game.score_rounds

raise "Oops, score should've been 12 but it was #{test_game.total_score}" unless test_game.total_score == 12

rounds = File.read('elven_strategy_guide.txt')
game = NewRockPaperScissors.new(rounds)
puts "The actual final score is #{game.total_score}"