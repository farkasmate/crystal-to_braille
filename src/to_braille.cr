require "colorize"
require "drawille-cr"
require "option_parser"

module ToBraille
  def self.render(canvas : Drawille::Canvas, clear : Bool = false)
    print "\33c\e[3J" if clear
    puts canvas.render.rstrip(" ")
    canvas.clear
  end

  delay = 0.milliseconds
  max_lines = Drawille::TERMINAL_LINES
  split = false
  skip = 0

  OptionParser.new do |parser|
    parser.banner = "Usage: to_braille [OPTIONS]"
    parser.on("-h", "--help", "Show this help") do
      puts parser
      exit
    end

    parser.on("-d", "--delay=N", "Delay in ms") { |n| delay = n.to_i }
    parser.on("-l", "--lines=N", "Max lines to read") do |n|
      split = true
      max_lines = n.to_i
    end
    parser.on("-s", "--skip=N", "Skip first N lines") { |n| skip = n.to_i }
  end.parse

  Colorize.enabled = false

  canvas = Drawille::Canvas.new

  skip.times { STDIN.read_line }

  STDIN.each_line.with_index do |line, line_index|
    line.each_char.with_index do |char, char_index|
      canvas.set(char_index, line_index % max_lines) unless char == ' '
    end

    if split && line_index > 0 && line_index % max_lines == 0
      render(canvas, split)
      sleep delay.milliseconds
    end
  end

  render(canvas, split)
end
