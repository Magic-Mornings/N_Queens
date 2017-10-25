require "n_queens"

describe NQueens do
  describe "Queen#test" do
    before :each do
      @queen = NQueens::Queen.new
    end

    it "returns 42" do
      expect(@queen.test).to eq 42
    end
  end

  describe "Board#test" do
    before :each do
      @board = NQueens::Board.new
    end

    it "returns 24" do
      expect(@board.test).to eq 24
    end
  end

end
