local helper = require "test.helper"
local assert = helper.assert
local command = helper.command

describe("upside_line source", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can go to the nearest target", function()
    helper.set_lines([[
  test1
test2]])
    command("normal! G")

    command("Hita upside_line")

    assert.window_count(2)

    helper.input_key("a")

    assert.window_count(1)
    assert.current_line("  test1")
    assert.column(3)
  end)

  it("does nothing on top", function()
    helper.set_lines([[
test1
test2]])
    command("normal! gg")

    command("Hita upside_line")

    assert.window_count(1)
    assert.current_line("test1")
  end)

end)
