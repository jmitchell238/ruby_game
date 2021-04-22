require 'studio_game/clumsy_player'

module StudioGame
  describe ClumsyPlayer do

    before do
      @player = ClumsyPlayer.new("klutz")
    end

    it "only gets half the point value for each treasure" do
      # @player.points.should == 0
      expect(@player.points).to eq(0)

      hammer = Treasure.new(:hammer, 50)
      @player.found_treasure(hammer)
      @player.found_treasure(hammer)
      @player.found_treasure(hammer)

      # @player.points.should == 75
      expect(@player.points).to eq(75)

      crowbar = Treasure.new(:crowbar, 400)
      @player.found_treasure(crowbar)

      # @player.points.should == 275
      expect(@player.points).to eq(275)

      yielded = []
      @player.each_found_treasure do |treasure|
        yielded << treasure
      end

      # yielded.should == [Treasure.new(:hammer, 75), Treasure.new(:crowbar, 200)]
      #
      expect(yielded).to eq([Treasure.new(:hammer, 75), Treasure.new(:crowbar, 200)])
    end

    context 'with a boost factor' do
      before do
        @initial_health = 100
        @boost_factor = 5
        @player = ClumsyPlayer.new('klutz', @initial_health, @boost_factor)
      end

      it 'has a boost factor' do
        expect(@player.boost_factor).to eq(5)
      end

      it 'gets boost factor number of w00ts when w00ted' do
        @player.w00t

        expect(@player.health).to eq(@initial_health + (15 * @boost_factor))
      end
    end


  end
end
