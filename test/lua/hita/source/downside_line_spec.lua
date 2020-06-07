local helper = require "test.helper"
local assert = helper.assert
local command = helper.command

describe('downside_line source', function ()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can go to the nearest target", function()
    helper.set_lines([[
test1
  test2
test3]])
    command("normal! gg")

    command("Hita downside_line")

    assert.window_count(2)

    helper.input_key("a")

    assert.window_count(1)
    assert.current_line("  test2")
    assert.column(3)
  end)

  it("does nothing on bottom", function()
    helper.set_lines([[
test1
test2]])
    command("normal! G")

    command("Hita downside_line")

    assert.window_count(1)
    assert.current_line("test2")
  end)

  it("saves the position before jump", function()
    helper.set_lines([[
test1
test2
test3]])

    command("Hita downside_line")

    assert.window_count(2)

    helper.input_key("a")

    assert.window_count(1)
    assert.current_line("test2")

    helper.jump_before()

    assert.current_line("test1")
  end)

end)
