# TODO: Write documentation for `ToBraille`
require "drawille-cr"

module ToBraille
  VERSION = "0.1.0"

  canvas = Drawille::Canvas.new

  STDIN.gets_to_end.each_line.with_index do |line, line_index|
    line.each_char.with_index do |char, char_index|
      canvas.set(char_index, line_index) unless char == ' '
    end
  end

  puts canvas.render
end
