$: << "#{File.expand_path('../../lib', __FILE__)}"

require 'chess'

describe Chess do
  let(:chess) { Chess.new }
  
  describe "#ensure_valid_origin" do
    context "with valid input" do
      it "@origin should equal 'b2' when entered as coordinates" do
        allow(chess).to receive(:gets).and_return("b2")
        expect {chess.ensure_valid_origin("white player")}.to output.to_stdout 
        expect(chess.origin).to eq("b2")
      end
    end

    context "with invalid input" do
      it "should output error message when 'i1' coordinates entered" do
        allow(chess).to receive(:gets).and_return("i1")
        expect {chess.ensure_valid_origin("white player")}.to output(
          "white player, please enter the coordinates of the piece you would like to move\nYou have entered an invalid coordinate. Please try again.\n"
          ).to_stdout  
      end
    end
  end

  describe "#ensure_valid_destination" do
    context "with valid input" do
      it "@destination should eq 'a1' when entered as coordinates" do
        allow(chess).to receive(:gets).and_return("a1")
        expect {chess.ensure_valid_destination("white player")}.to output.to_stdout
        expect(chess.destination).to eq("a1")
      end
    end
  end

  describe "#resign_game?" do
    context "with 'n' input" do
      it "should return false" do
        allow(chess).to receive(:gets).and_return("n")
        expect(chess.resign_game?("black", "white")).to be_falsey
      end
    end

    context "with 'y' input" do
      it "should return true" do
        allow(chess).to receive(:gets).and_return("y")
        expect(chess.resign_game?("black", "white")).to be_truthy
      end

      it "should output victory message" do
        allow(chess).to receive(:gets).and_return("y")
        expect {chess.resign_game?("black", "white")}.to output(
          "black, do you want to resign? (y/n)\nblack has resigned. white wins!\n").to_stdout
      end
    end
  end

  describe "#propose_draw" do
    context "with 'n' input" do
      it "should return false" do
        allow(chess).to receive(:gets).and_return("n")
        expect(chess.propose_draw("black", "white")).to be_falsey
      end
    end

    context "with 'y' input" do
      it "should run #accept_draw_proposal?" do
        allow(chess).to receive(:gets).and_return("y")
        expect(chess).to receive(:accept_draw_proposal?)
        chess.propose_draw("black", "white")
      end
    end
  end

  describe "#accept_draw_proposal?" do
    context "with 'n' input" do
      it "should return false" do
        allow(chess).to receive(:gets).and_return("n")
        expect(chess.accept_draw_proposal?("black", "white")).to be_falsey
      end
    end

    context "with 'y' input" do
      it "should return true" do
        allow(chess).to receive(:gets).and_return("y")
        expect(chess.accept_draw_proposal?("black", "white")).to be_truthy
      end

      it "should output message that the game is drawn" do
        allow(chess).to receive(:gets).and_return("y")
        expect {chess.accept_draw_proposal?("black", "white")}.to output(
        "black has proposed a draw. white, do you accept the proposal? (y/n)\nwhite has accepted your proposal to draw. The game is a draw.\n"
        ).to_stdout
      end
    end
  end

  describe "#load_saved_game" do
    context "with 'n' input" do
      it "return nil" do
        allow(chess).to receive(:gets).and_return("n")
        expect(chess.load_saved_game).to be nil
      end
    end

    context "with 'y' input" do
      it "run #select_game_to_load" do
        allow(chess).to receive(:gets).and_return("y")
        expect(chess).to receive(:select_game_to_load)
        chess.load_saved_game
      end
    end
  end

  describe "#saved_game" do
    context "with 'n' input" do
      it "return nil" do
        allow(chess).to receive(:gets).and_return("n")
        expect(chess.save_game).to be nil
      end
    end

    context "with 'y' input" do
      it "run #determine_saved_file_name" do
        allow(chess).to receive(:gets).and_return("y")
        expect(chess).to receive(:determine_saved_file_name)
        chess.save_game
      end
    end
  end

  describe "#determine_saved_file_name" do
    context "with 'n' input" do
      it "should run #name_saved_file" do
        allow(chess).to receive(:gets).and_return("n")
        expect(chess).to receive(:name_saved_file)
        chess.determine_saved_file_name
      end
    end

    context "with 'y' input" do
      it "should run #File.open" do
        allow(chess).to receive(:gets).and_return("y")
        expect(File).to receive(:open)
        chess.determine_saved_file_name
      end

      it "should not run #name_saved_file" do
        allow(chess).to receive(:gets).and_return("y")
        chess.filename = "test"
        expect(File).to receive(:open)
        expect(chess).not_to receive(:name_saved_file)
        chess.determine_saved_file_name
      end

      it "should create a 'test1.txt' file and save into it" do
        allow(chess).to receive(:gets).and_return("y")
        chess.filename = "test1"
        file = double("file")
        allow(File).to receive(:open).with("../saved_games/#{chess.filename}.txt", "w").and_yield(file)
        expect(file).to receive(:puts).with(chess.marshal_save_game)
        chess.determine_saved_file_name
      end
    end
  end

  describe "#name_saved_file" do
    context "with 'test2' input" do
      it "should create 'test2.txt' file and save" do
        allow(chess).to receive(:gets).and_return("test2")
        chess.filename = "test2"
        file = double("file")
        allow(File).to receive(:open).with("../saved_games/#{chess.filename}.txt", "w").and_yield(file)
        expect(file).to receive(:puts).with(chess.marshal_save_game)
        chess.name_saved_file
      end
    end
  end

  describe "#select_game_to_load" do
    context "with '1' input" do
      it "should run #from_marshal_string" do
        allow(chess).to receive(:gets).and_return("1")
        file = double("file")
        allow(File).to receive(:open).with(Dir.glob("../saved_games/*")[0], "r").and_yield(file)
        expect(chess).to receive(:from_marshal_string).with(file)
        chess.select_game_to_load
      end
    end
  end

  describe "#claim_threefold_repetition_draw?" do
    context "with 'n' input" do
      it "should return false" do
        allow(chess).to receive(:gets).and_return("n")
        expect(chess.claim_threefold_repetition_draw?("white")).to eq false
      end
    end

    context "with 'y' input" do
      it "should return true" do
        allow(chess).to receive(:gets).and_return("y")
        expect(chess.claim_threefold_repetition_draw?("white")).to eq true
      end
    end
  end
end
