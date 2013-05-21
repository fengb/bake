require 'test/unit/assertions'


class Expect
  include Test::Unit::Assertions

  def initialize(obj)
    @obj = obj
  end

  def ==(other)
    assert_equal(other, @obj)
  end

  module Helper
    def expect(*args)
      Expect.new(*args)
    end
  end
end
World(Expect::Helper)
