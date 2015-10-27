class ValueError < Exception
end

class Board

  module Visitors
    class Visitor
      attr_reader :input

      def initialize(input)
        @input = input
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

    class ValidationVisitor < Visitor

      def initialize(input)
        super input
      end

      def visit(value, x, y)
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
    end

    class CountExposureVisitor < Visitor
      attr_reader :output

      def initialize(input)
        super input
        @output = []
      end

      def visit(value, x, y)
        @output << '' if x == 0
        processed_row = @output.last
        if value == ' '
          count = detect_count x, y
          processed_row << (count>0 ? count.to_s : ' ')
        else
          processed_row << value
        end
      end

      private

      def detect_count(x, y)
        count = 0
        [[-1,-1], [0,-1], [1,-1], [1,0], [1,1], [0,1], [-1,1], [-1,0]].each do |operands|
          neighbour_x = x + operands[0]
          neighbour_y = y + operands[1]
          next if !in_range?(neighbour_x, neighbour_y)
          count += 1 if input[neighbour_y][neighbour_x] == '*'
        end
        count
      end
    end
  end

  class BoardParser

    attr_reader :input

    def initialize(input)
      @input = input
      @cell_visitors = []
    end

    def <<(visitor)
      @cell_visitors << visitor
    end

    def parse
      check_width
      parse_rows
    end

    def check_width
      return if !input || input.empty?
      length = input.first.length
      input.each { |el| raise ValueError.new('invalid board') if el.length != length }
    end

    def parse_rows
      input.each_with_index { |row, row_idx| parse_row row, row_idx }
    end

    def parse_row(row, row_idx)
      row.each_char.with_index do |char,col_idx|
        @cell_visitors.each { |visitor| visitor.visit char, col_idx, row_idx }
      end
    end
  end

  def self.transform(input)
    parser = BoardParser.new input

    countExpVisitor = Visitors::CountExposureVisitor.new(input)
    parser << Visitors::ValidationVisitor.new(input)
    parser << countExpVisitor

    parser.parse
    countExpVisitor.output
  end
end