require 'sinatra'
require 'sinatra/reloader'

@@guess_left = 12
@@all_guesses = []
@@current_guess = ""

def generate_code
	code = []
	4.times do |n|
		code[n] = rand(1..6)		
	end
	code
end

@@code = generate_code

def valid_code?(code)
	
	return false if code.size != 4
	
	code.split("").each do |digit|
		if !(1..6).to_a.include? digit.to_i
			return false
		end
	end
	true
end

def get_feedback(guess)

	guess = guess.split("").map { |n| n.to_i }

	secret_copy = @@code.dup
	guess_copy = guess.dup
	feedback = []

	(guess_copy.size - 1).downto(0) do |n|
		if guess_copy[n] == secret_copy[n]
			feedback << "X"
			guess_copy.delete_at(n)
			secret_copy.delete_at(n)
		end
	end

	(guess_copy.size - 1).downto(0) do |x|
		(secret_copy.size - 1).downto(0) do |y|
			if guess_copy[x] == secret_copy[y]
				feedback << "O"
				guess_copy.delete_at(x)
				secret_copy.delete_at(y)
			end
		end
	end

	if feedback == []
		feedback = ["nothing"]
	end
	feedback.join
end

def validate_guess(guess)
	@@current_guess = @guess
	@@all_guesses << [@guess, @feedback]
	@@guess_left -= 1
end

def win?
	return true if @@current_guess == @@code.join
	false
end

def lose?
	return true if @@guess_left == 0
	false
end

def play_game
	if @guess
		if valid_code?(@guess)
			@feedback = get_feedback(@guess)
			validate_guess(@guess)
		end
	else
		@@guess_left = 12
		@@all_guesses = []
		@@code = generate_code
	end
end

get "/" do
	@guess = params["guess"]
	play_game

	erb :index, :locals => {:feedback => @feedback, :guess => @guess}
end
