local helper = require "test.helper"
local assert = helper.assert
local command = helper.command

describe("window_word source", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can go to the nearest target", function()
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
