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

end)
