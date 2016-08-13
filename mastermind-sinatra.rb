require 'sinatra'
require 'sinatra/reloader' if development?

helpers do
	def evaluate(guess, code)
		feedback = []
		to_check = []
		guess = guess.split("") if guess.is_a? String
		code = code.split("") if code.is_a? String
		(0...code.size).each do |i|
			to_check[i] = true
		end
		to_check.each_with_index do |check, i|
			if check
				if code[i] == guess[i]
					feedback.push("B") 
					to_check[i] = false
				end
			end
		end
		# to_check is an array the size of the code that indicates wether an index is to check ([false, true, true, true])
		# find all symbols in code that haven't been checked, code[i] hasn't been checked if to_check[i] is true
		values_to_match = []
		code.each_index do |i| 
			if to_check[i]
				values_to_match << code[i]
			end
		end 

		guess.each_with_index do |symbol, i|
			if to_check[i]
				feedback.push("W") if values_to_match.include?(guess[i])
			end
		end

		(0..3).each do |i|
			unless feedback[i]
				feedback[i] = "X"
			end
		end
		
		return feedback
	end

	def generate_code
		code = []

		4.times do |i|
			code.push((rand * 5).round)
		end

		return code.join("")
	end
end

configure do 
	enable :sessions
end

get '/' do
	if session[:code].nil?
		puts "Redirecting"
		redirect to "/newgame"
	end
	
	if session[:tries] == 0 
		# you lose
		session.clear
		erb :you_lose
	elsif session[:feedback_history][-1] == "BBBB"
		# you win
		session.clear
		erb :you_win
	else
		erb :index, :locals => {:error => nil, :feedback => session[:feedback_history][-1], :tries_left => session[:tries], :code => session[:code]}
	end
	#erb :index
end

post '/' do
	# evaluate guess in params
	guess = params["digit1"] + params["digit2"] + params["digit3"] + params["digit4"]
	if guess.include?("-1")
		error = "Your guess isn't complete!"
		erb :index, :locals => {:error => error, :feedback => nil, :tries_left => session[:tries], :code => session[:code]} 
	else
		feedback = evaluate(guess, session[:code]).join("")
		session[:guess_history].push(guess)
		session[:feedback_history].push(feedback)
		session[:tries] -= 1
		redirect to("/")
	end
end

get '/newgame' do
	# set secret code
	session[:code] = generate_code
	# set tries left back to 12
	session[:tries] = 12
	# clear guess_history and feedback_history
	session[:guess_history] = []
	session[:feedback_history] = []
	redirect to "/"
end

