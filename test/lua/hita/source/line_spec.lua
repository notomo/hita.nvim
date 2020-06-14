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
    assert.current_line("1_a_b_ca")

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

  it("cancels on leaving the buffer", function()
    helper.set_lines("1_2_3_4")

    local cursor = helper.cursor()

    command("Hita line")

    assert.window_count(2)

    command("buffer #")

    assert.window_count(1)
    assert.cursor(cursor)
  end)

  it("displays hint on wrapped line end", function()
    vim.bo.textwidth = 30
    vim.wo.wrap = true
    helper.set_lines("z________________________________________________________________________________________________________z")

    command("Hita line")

    assert.window_count(2)
    assert.window_height(2)
    assert.current_line("z________________________________________________________________________________________________________a")

    helper.input_key("a")

    assert.window_count(1)
    assert.window_relative_row(2)
  end)

  it("displays hint on wrapped line start", function()
    vim.bo.textwidth = 30
    vim.wo.wrap = true
    helper.set_lines("z________________________________________________________________________________________________________z")
    command("normal! $")

    command("Hita line")

    assert.window_count(2)
    assert.window_height(2)
    assert.window_relative_row(2)
    assert.current_line("a________________________________________________________________________________________________________z")

    helper.input_key("a")

    assert.window_count(1)
    assert.window_relative_row(1)
  end)

  it("can displays hints on line including multibyte chars", function()
    require "hita/hint".chars = "abc"
    helper.set_lines("ああhoge_foo")

    command("Hita line")

    assert.window_count(2)
    assert.current_line("ああaoge_boo")

    helper.input_key("a")

    assert.window_count(1)
    assert.current_char("h")
  end)

  it("can displays hints on line including tab chars", function()
    require "hita/hint".chars = "abc"
    helper.set_lines("\t\thoge_foo")

    command("Hita line")

    assert.window_count(2)
    assert.current_line("\t\taoge_boo")

    helper.input_key("a")

    assert.window_count(1)
    assert.current_char("h")
  end)

  it("can displays hints on line including tab chars with signcolumn", function()
    vim.wo.signcolumn = "yes:5"
    vim.wo.numberwidth = 4
    vim.wo.number = true
    require "hita/hint".chars = "abc"
    helper.set_lines("\t\thoge_foo")

    command("Hita line")

    assert.window_count(2)
    assert.current_line("\t\taoge_boo")

    helper.input_key("a")

    assert.window_count(1)
    assert.current_char("h")
  end)

end)
