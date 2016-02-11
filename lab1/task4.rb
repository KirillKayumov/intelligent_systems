def rand_int(limit) # функция для получения случайного целого числа от 1 до limit
  (1..limit).to_a.sample
end

class Agent # простой рефлексивный агент
  def reflex(move_options, status)
    move_options.select! { |_, value| value }
    action = move_options.to_a.sample.first # случайное определение направления движения

    if status == :dirty
      :suck
    else
      action
    end
  end
end

class Environment # описание среды
  attr_reader :map, :map_width, :map_height

  AGENT_LIFE_TIME = 1000 # время работы агента

  def initialize
    @map_height, @map_width = rand_int(10), rand_int(10)
    @map = []

    map_height.times do # случайное построение среды
      @map << []
      map_width.times do
        @map.last << (rand_int(100) % 3 == 0 ? :dirty : :clean)
      end
    end
  end

  def run
    agent = Agent.new
    points = 0 # очки, набранные агентом
    location = [0, 0] # начальная позиция агента

    AGENT_LIFE_TIME.times do |time|
      move_options = { # структура с определениями, куда агент может передвигаться
        :up => location.first > 0,
        :right => location.last < map_width - 1,
        :down => location.first < map_height - 1,
        :left => location.last > 0
      }

      action = agent.reflex(move_options, map[location.first][location.last])

      if action == :suck
        map[location.first][location.last] = :clean
        points += 1 # прибавляем очки за очищенные клетки
      elsif action == :up
        location[0] -= 1
      elsif action == :right
        location[1] += 1
      elsif action == :down
        location[0] += 1
      elsif action == :left
        location[1] -= 1
      end
    end

    points # возвращаем кол-во набранных очков
  end
end

environment = Environment.new

environment.map.each do |row|
  print row
  puts
end

points = environment.run

puts "Points: #{points}"
