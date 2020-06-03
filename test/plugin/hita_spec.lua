local helper = require "test.helper"
local assert = helper.assert
local command = helper.command

describe("plugin.hita", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("default", function()
    helper.set_lines([[
test1
test2
test3
test4]])
    command("normal! 2j")

    command("Hita")

    assert.window_count(2)

    helper.input_key("a")

    assert.window_count(1)
    assert.current_line("test2")
  end)

  it("upside", function()
    helper.set_lines([[
test1
test2]])
    command("normal! G")

    command("Hita upside_line")

    assert.window_count(2)

    helper.input_key("a")

    assert.window_count(1)
    assert.current_line("test1")
  end)

  it("upside on top", function()
    helper.set_lines([[
test1
test2]])
    command("normal! gg")

    command("Hita upside_line")

    assert.window_count(1)
    assert.current_line("test1")
  end)

  it("downside", function()
    helper.set_lines([[
test1
test2
test3]])
    command("normal! gg")

    command("Hita downside_line")

    assert.window_count(2)

    helper.input_key("a")

    assert.window_count(1)
    assert.current_line("test2")
  end)

  it("downside on bottom", function()
    helper.set_lines([[
test1
test2]])
    command("normal! G")

    command("Hita downside_line")

    assert.window_count(1)
    assert.current_line("test2")
  end)

  it("line", function()
    helper.set_lines("123_456_789")

    command("Hita line")

    assert.window_count(2)

    helper.input_key("a")

    assert.window_count(1)
    assert.current_char("4")
  end)

  it("two chars", function()
    require "hita/window".chars = "abc"
    helper.set_lines("1_2_3_4")

    command("Hita line")

    assert.window_count(2)
    assert.current_line_startswith("  a b ca")

    helper.input_key("ca")

    assert.window_count(1)
    assert.current_char("4")
  end)

  it("window_word", function()
    helper.set_lines([[
test1
test2
test3]])
    command("normal! j")

    command("Hita window_word")

    assert.window_count(2)

    helper.input_key("a")

    assert.window_count(1)
    assert.current_line("test1")
  end)

end)
