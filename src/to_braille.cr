require "colorize"
require "drawille-cr"

module ToBraille
  Colorize.enabled = false

  canvas = Drawille::Canvas.new

  STDIN.gets_to_end.each_line.with_index do |line, line_index|
    line.each_char.with_index do |char, char_index|
      canvas.set(char_index, line_index) unless char == ' '
    end
  end

  puts canvas.render.rstrip(" ")
end
