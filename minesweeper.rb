require 'pry'

class ValueError < Exception
end

class Board

  class BoardProcessor
    attr_reader :input
    attr_reader :output

    def initialize(input)
      @input = input
      @output = []
    end

    def process
      process_rows
    end

    def process_rows
      input.each_with_index { |row, row_idx| process_row row, row_idx }
    end

    def process_row(row, row_idx)
      row.each_char.with_index { |char,col_idx| process_cell char, col_idx, row_idx }
    end

    def process_cell(value, x, y)
      if x == 0
        @output << ''
      end
      processed_row = @output.last
      if value == ' '
        count = detect_count x, y
        processed_row << (count>0 ? count.to_s : ' ')
      else
        processed_row << value
      end
    end

    def detect_count(x, y)
      count = 0
      [[-1,-1], [0,-1], [1,-1], [1,0], [1,1], [0,1], [-1,1], [-1,0]].each do |operands|
        neighbour_x = x + operands[0]
        neighbour_y = y + operands[1]
        next if !in_range?(neighbour_x, neighbour_y)
        if input[neighbour_y][neighbour_x] == '*'
          count += 1
        end
      end
      count
    end

    def in_range?(x, y)
      x >= 0 && x < width && y >= 0 && y < height
    end

    def width
      input.first.length
    end

    def height
      input.length
    end
  end

  class BoardValidator

    attr_reader :input

    def initialize(input)
      @input = input
    end

    def validate
      validate_width
      validate_rows
    end

    def validate_width
      return true if !input || input.empty?
      length = input[0].length
      proc = Proc.new { |el| return if el.length != length }
      input.each &proc
    end

    def validate_rows
      input.each_with_index { |row, row_idx| validate_row row, row_idx }
    end

    def validate_row(row, row_idx)
      row.each_char.with_index { |char,col_idx| validate_cell char, col_idx, row_idx }
    end

    def validate_cell(value, x, y)
      if y == 0 || y == height-1
        if x == 0 || x == width-1
          raise ValueError.new("+ expected on position [#{x}, #{y}]") if value != '+'
        elsif x > 0 && x < width-1
          raise ValueError.new("- expected on position [#{x}, #{y}]") if value != '-'
        end
      else
        if x == 0 || x == width-1
          raise ValueError.new("| expected on position [#{x}, #{y}]") if value != '|'
        else
          raise ValueError.new("#{value} not expected on position [#{x}, #{y}]") if value != ' ' && value != '*'
        end
      end
    end

    def width
      input.first.length
    end

    def height
      input.length
    end
  end

  def self.transform(input)
    parse input
  end

  private

  def self.parse(input)
    v = BoardValidator.new input
    v.validate

    p = BoardProcessor.new input
    p.process

    p.output
  end

end