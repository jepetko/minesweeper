![CircleCI state](https://circleci.com/gh/jepetko/minesweeper.png?circle-token=1af4af3ace9ad752f06f9dd86385bc2683adff3e&style=shield)

Minesweeper is a popular game where the user has to find the mines using numeric hints that indicate how many mines are directly adjacent (horizontally, vertically, diagonally) to a square.

In this exercise you have to create some code that counts the number of mines adjacent to a square and transforms boards like this (where * indicates a mine):

```
+-----+
| * * |
|  *  |
|  *  |
|     |
+-----+
```

into this:

```
+-----+
|1*3*1|
|13*31|
| 2*2 |
| 111 |
+-----+
```

The test suite:

```ruby
require 'minitest/autorun'
require_relative 'minesweeper'

class MinesweeperTest < Minitest::Test
  def test_transform1
    inp = ['+------+', '| *  * |', '|  *   |', '|    * |', '|   * *|',
           '| *  * |', '|      |', '+------+']
    out = ['+------+', '|1*22*1|', '|12*322|', '| 123*2|', '|112*4*|',
           '|1*22*2|', '|111111|', '+------+']
    assert_equal out, Board.transform(inp)
  end

  def test_transform2
    skip
    inp = ['+-----+', '| * * |', '|     |', '|   * |', '|  * *|',
           '| * * |', '+-----+']
    out = ['+-----+', '|1*2*1|', '|11322|', '| 12*2|', '|12*4*|',
           '|1*3*2|', '+-----+']
    assert_equal out, Board.transform(inp)
  end

  def test_transform3
    skip
    inp = ['+-----+', '| * * |', '+-----+']
    out = ['+-----+', '|1*2*1|', '+-----+']
    assert_equal out, Board.transform(inp)
  end

  def test_transform4
    skip
    inp = ['+-+', '|*|', '| |', '|*|', '| |', '| |', '+-+']
    out = ['+-+', '|*|', '|2|', '|*|', '|1|', '| |', '+-+']
    assert_equal out, Board.transform(inp)
  end

  def test_transform5
    skip
    inp = ['+-+', '|*|', '+-+']
    out = ['+-+', '|*|', '+-+']
    assert_equal out, Board.transform(inp)
  end
  def test_transform6
    skip
    inp = ['+--+', '|**|', '|**|', '+--+']
    out = ['+--+', '|**|', '|**|', '+--+']
    assert_equal out, Board.transform(inp)
  end

  def test_transform7
    skip
    inp = ['+--+', '|**|', '|**|', '+--+']
    out = ['+--+', '|**|', '|**|', '+--+']
    assert_equal out, Board.transform(inp)
  end

  def test_transform8
    skip
    inp = ['+---+', '|***|', '|* *|', '|***|', '+---+']
    out = ['+---+', '|***|', '|*8*|', '|***|', '+---+']
    assert_equal out, Board.transform(inp)
  end

  def test_transform9
    skip
    inp = ['+-----+', '|     |', '|   * |', '|     |', '|     |',
           '| *   |', '+-----+']
    out = ['+-----+', '|  111|', '|  1*1|', '|  111|', '|111  |',
           '|1*1  |', '+-----+']
    assert_equal out, Board.transform(inp)
  end

  def test_different_len
    skip
    inp = ['+-+', '| |', '|*  |', '|  |', '+-+']
    assert_raises(ValueError) do
      Board.transform(inp)
    end
  end

  def test_faulty_border
    skip
    inp = ['+-----+', '*   * |', '+-- --+']
    assert_raises(ValueError) do
      Board.transform(inp)
    end
  end
  def test_invalid_char
    skip
    inp = ['+-----+', '|X  * |', '+-----+']
    assert_raises(ValueError) do
      Board.transform(inp)
    end
  end
end
```
