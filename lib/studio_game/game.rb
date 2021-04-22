require_relative 'player'
require_relative 'game_turn'
require_relative 'treasure_trove'

module StudioGame
  class Game
    attr_reader :title
    def initialize(title)
      @title = title
      @players = []
    end

    def load_players(from_file)
      File.readlines(from_file).each do |line|
        add_player(Player.from_csv(line))
      end
    end

    def add_player(a_player)
      @players << a_player
    end

    def play(rounds)
      puts "\nThere are #{@players.size} players in #{@title}:"

      @players.each do |player|
        puts player
      end

      puts "\n"

      treasures = TreasureTrove::TREASURES
      puts "There are #{treasures.size} treasures to be found:"
      treasures.each do |treasure|
        puts "A #{treasure.name} is worth #{treasure.points} points."
      end

      puts "\n"

      1.upto(rounds) do |round|
        if block_given?
          break if yield
        end
        puts "\nRound #{round}:"
        @players.each do |player|
          GameTurn.take_turn(player)
          puts player
        end
      end
    end

    def print_name_and_health(player)
      puts "#{player.name} (#{player.health})"
    end

    def total_points
      total = 0
      @players.sort.each do |player|
        total += player.points
      end
      total
    end

    def high_score_entry(player)
      "#{player.name.ljust(20, '.')} (#{player.score})"
    end

    def save_high_scores(to_file="high_scores.txt")
      File.open(to_file, "w") do |file|
        file.puts "#{@title} High Scores:"
        @players.sort.each do |player|
          file.puts high_score_entry(player)
        end
      end
    end

    def print_stats
      puts "\n#{title} Statistics:"

      strong_players, wimpy_players = @players.partition { |player| player.strong? }

      puts "#{strong_players.size} strong players:"
      strong_players.each do |player|
        print_name_and_health(player)
      end

      puts "#{wimpy_players.size} wimpy players:"
      wimpy_players.each do |player|
        print_name_and_health(player)
      end

      puts "\n#{@title} High Scores:\n"
      @players.sort.each do |player|
        puts high_score_entry(player)
      end

      puts "\n"
      @players.sort.each do |player|
        puts "\n#{player.name}'s point totals:"

        player.each_found_treasure do |treasure|
          puts "#{treasure.points} total #{treasure.name} points."
        end

        puts "#{player.points} grand total points."
      end

      puts "\nTotal game points:\n#{total_points}"

    end


  end
end

