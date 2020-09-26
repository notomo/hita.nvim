local helper = require "test.helper"
local assert = helper.assert
local command = helper.command

describe("search source", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can go to the nearest target", function()
    helper.set_lines([[

test1
test2
test3]])
    command("/test")

    command("Hita search")

    assert.window_count(2)

    helper.input_key("a")

    assert.window_count(1)
    assert.current_line("test2")
  end)

  it("does nothing if register is empty", function()
    helper.set_lines([[

test1
test2
test3]])
    command("let @/ = ''")

    command("Hita search")

    assert.window_count(1)
  end)

end)
