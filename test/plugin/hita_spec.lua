local helper = require "test.helper"
local assert = helper.assert
local command = helper.command

describe("plugin.hita", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("default", function()
    command("Hita")

    assert.window_count(2)

    helper.input_key("a")

    assert.window_count(1)
  end)

  it("upside", function()
    helper.set_lines([[
    test1
    test2
    ]])
    command("normal! G")
    local line = vim.fn.line(".")

    command("Hita upside_line")

    assert.window_count(2)

    helper.input_key("a")

    assert.window_count(1)
    assert.line_number(line - 1)
  end)

  it("upside on top", function()
    local line = vim.fn.line(".")

    command("Hita upside_line")

    assert.window_count(1)
    assert.line_number(line)
  end)

  it("downside", function()
    helper.set_lines([[
    test1
    test2
    test3
    ]])
    command("normal! gg")
    local line = vim.fn.line(".")

    command("Hita downside_line")

    assert.window_count(2)

    helper.input_key("a")

    assert.window_count(1)
    assert.line_number(line + 1)
  end)

  it("downside on bottom", function()
    local line = vim.fn.line(".")

    command("Hita downside_line")

    assert.window_count(1)
    assert.line_number(line)
  end)

end)
