local helper = require "test.helper"
local assert = helper.assert
local command = helper.command

describe('line source', function ()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can go to the nearest target", function()
    helper.set_lines("123_456_789")

    command("Hita line")

    assert.window_count(2)

    helper.input_key("a")

    assert.window_count(1)
    assert.current_char("4")
  end)

  it("can handle two characters target", function()
    require "hita/hint".chars = "abc"
    helper.set_lines("1_2_3_4")

    command("Hita line")

    assert.window_count(2)
    assert.current_line_startswith("  a b ca")

    helper.input_key("ca")

    assert.window_count(1)
    assert.current_char("4")
  end)

  it("can be canceled", function()
    helper.set_lines("1_2_3_4")

    local cursor = helper.cursor()

    command("Hita line")

    assert.window_count(2)

    helper.input_key("j")

    assert.window_count(1)
    assert.cursor(cursor)
  end)

  it("cancels on leaving the window", function()
    helper.set_lines("1_2_3_4")

    local cursor = helper.cursor()

    command("Hita line")

    assert.window_count(2)

    command("wincmd p")

    assert.window_count(1)
    assert.cursor(cursor)
  end)

end)
