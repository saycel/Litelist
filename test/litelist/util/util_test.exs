defmodule Litelist.UtilTest do
    use Litelist.DataCase

    alias Litelist.Util
    describe "slugify" do
        test "returns a downcased string with dashes in place of spaces" do
            arg = "Some String"
            expect = "some-string"
            assert Util.slugify(arg) == expect
        end

        test "returns nil if nil" do
            arg = nil
            expect = nil
            assert Util.slugify(arg) == expect
        end

        test "returns an unchanged string if already lower case without spaces" do
            arg = "lower"
            expect = "lower"
            assert Util.slugify(arg) == expect
        end
    end
end