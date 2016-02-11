class Agent
  def reflex(location, status)
    if status == :dirty
      :suck
    elsif location == 0
      :right
    elsif location == 1
      :left
    end
  end
end

class Environment
  attr_reader :map

  AGENT_LIFE_TIME = 1000

  def initialize(map)
    @map = map
  end

  def run(location)
    agent = Agent.new
    points = 0

    AGENT_LIFE_TIME.times do |time|
      action = agent.reflex(location, map[location])
      if action == :suck
        map[location] = :clean
        points += 1
      elsif action == :right
        location = 1
      elsif action == :left
        location = 0
      end
    end

    points
  end
end

average_points = 0

[
  [[:dirty, :dirty], 0],
  [[:dirty, :dirty], 1],
  [[:clean, :dirty], 0],
  [[:clean, :dirty], 1],
  [[:dirty, :clean], 0],
  [[:dirty, :clean], 1],
  [[:clean, :clean], 0],
  [[:clean, :clean], 1]
].each do |map, location|
  print "#{map} | "
  environment = Environment.new map
  points = environment.run location
  average_points += points

  puts "Points: #{points}"
end

puts "Average points: #{average_points / 8}"
