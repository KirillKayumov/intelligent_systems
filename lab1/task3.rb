class Agent # простой рефлексивный агент
  attr_accessor :cleaned_locations

  def initialize
    @cleaned_locations = [] # внутреннее состояние – список очищенных агентом клеток
  end

  def reflex(location, status)
    if status == :dirty
      cleaned_locations << location # обновляем внутреннее состояние
      :suck
    elsif location == 0 && !cleaned_locations.include?(1) # не идем в уже почищенную клетку
      :right
    elsif location == 1 && !cleaned_locations.include?(0) # не идем в уже почищенную клетку
      :left
    else
      :no_action
    end
  end
end

class Environment # описание среды
  attr_reader :map

  AGENT_LIFE_TIME = 1000 # время работы агента

  def initialize(map)
    @map = map
  end

  def run(location)
    agent = Agent.new
    points = 0 # очки, набранные агентом
    penalty = 0 # штраф

    AGENT_LIFE_TIME.times do |time|
      action = agent.reflex(location, map[location])
      if action == :suck
        map[location] = :clean
        points += 1 # прибавляем очки за очищенные клетки
      elsif action == :right
        location = 1
      elsif action == :left
        location = 0
      elsif action == :no_action
        next # не назначаем штраф, когда агент не совершал действий
      end

      penalty += 1
    end

    [points, penalty] # возвращаем кол-во набранных очков и штраф
  end
end

average_points = 0
# вывод статистики на всех возможных конфигурациях
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
  points, penalty = environment.run location
  average_points += points

  puts "Points: #{points} | Penalty: #{penalty}"
end

puts "Average points: #{average_points / 8}"
