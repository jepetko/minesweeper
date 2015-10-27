require 'pry'

class ValueError < Exception
end

class Board

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
      row.each_char.with_index { |char,col_idx| validate_value char, col_idx, row_idx }
    end

    def validate_value(value, x, y)
      if y == 0 || y == height-1
        if x == 0 || x == width-1
          raise ValueError.new("+ expected on position [#{x}, #{y}]") if value != '+'
        end
        if x > 0 && x < width-1
          raise ValueError.new("- expected on position [#{x}, #{y}]") if value != '-'
        end
      else
        if x == 0 || x == width-1
          raise ValueError.new("| expected on position [#{x}, #{y}]") if value != '|'
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
  end

end