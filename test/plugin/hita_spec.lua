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

end)
