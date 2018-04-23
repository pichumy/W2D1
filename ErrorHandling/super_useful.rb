# PHASE 2
def convert_to_int(str)
  Integer(str)
rescue ArgumentError => e
  print e.message
  nil
end

# PHASE 3
FRUITS = ["apple", "banana", "orange"]

def reaction(maybe_fruit)
  if FRUITS.include? maybe_fruit
    puts "OMG, thanks so much for the #{maybe_fruit}!"
  elsif maybe_fruit == "coffee"
    raise CoffeeError.new("Yay! Coffee is nice, but please give me a fruit!!")
  else
    raise StandardError.new("No thank you. I only eat #{FRUITS.join(", ")}, and maybe ...coffee?.")
  end
end

def feed_me_a_fruit
  puts "Hello, I am a friendly monster. :)"
  begin
    puts "Feed me a fruit! (Enter the name of a fruit:)"
    maybe_fruit = gets.chomp
    reaction(maybe_fruit)
  rescue CoffeeError => e
    puts e.message
    retry
  rescue StandardError => e
    puts e.message
    puts "Standard Error"
  end
end

class CoffeeError < StandardError
end

# PHASE 4
class BestFriend
  def initialize(name, yrs_known, fav_pastime)
    raise "Not best friends. Requires 5 years of intense friendship." if yrs_known < 5
    raise "No Name? Provide a name." if name.empty?
    raise "No favorite pastimes? What do you like to do?" if fav_pastime.empty?
    @name = name
    @yrs_known = yrs_known
    @fav_pastime = fav_pastime
  end

  def talk_about_friendship
    puts "Wowza, we've been friends for #{@yrs_known}. Let's be friends for another #{1000 * @yrs_known}."
  end

  def do_friendstuff
    puts "Hey bestie, let's go #{@fav_pastime}. Wait, why don't you choose. 😄"
  end

  def give_friendship_bracelet
    puts "Hey bestie, I made you a friendship bracelet. It says my name, #{@name}, so you never forget me."
  end
end
