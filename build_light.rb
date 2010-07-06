# Delcom build light controller
#
# Written by Josh Price, ThoughtWorks

class BuildLight
  BLUE = 0b100
  RED = 0b010
  GREEN = 0b001
  YELLOW = 0b011
  ALL = 0b111
  MASK = ALL ^ ~0

  def building
    set_flash_timing BLUE, 100, 10
    flashing_on BLUE
  end

  def success
    flashing_off ALL
    turn on(GREEN)
  end

  def partial_success
    flashing_off ALL
    turn on(YELLOW)
  end

  def fail
    flashing_off ALL
    turn on(RED)
  end

  def reset
    flashing_off ALL
    turn off(ALL)
  end

  def warning
    flashing_off ALL
    turn on(BLUE)
  end

private
  def on(color)
    ~color ^ MASK
  end

  def off(color)
    color
  end

  def turn(light)
    execute "turn", "10 2 #{light} 0"
  end

  def flashing_on(light)
    execute "flashing on", "10 20 0 #{light}"
  end

  def flashing_off(light)
    execute "flashing off", "10 20 #{light} 0"
  end

  def set_flash_timing(light, off_time_ms, on_time_ms)
    cmd_map = { BLUE => 23, RED => 22, GREEN => 21 }
    execute "set flash timing", "10 #{cmd_map[light]} #{off_time_ms} #{on_time_ms}"
  end

  def execute(name, command)
    #puts "#{name}: #{command}"
    `light #{command}`
  end
end
