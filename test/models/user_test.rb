require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "requires a name" do
    @user =
      User.new(name: "", email: "johndoe@example.com", password: "password")
    refute @user.valid?
    @user.name = "John"
    assert @user.valid?
  end

  test "requires a valid email" do
    @user = User.new(name: "John", email: "", password: "password")
    refute @user.valid?

    @user.email = "invalid"
    refute @user.valid?

    @user.email = "johndoe@example.com"
    assert @user.valid?
  end

  test "requires a unique email" do
    @existing_user =
      User.create(name: "John", email: "jd@example.com", password: "password")
    assert @existing_user.persisted?

    @user = User.new(name: "Jon", email: "jd@example.com", password: "password")
    refute @user.valid?
  end

  test "user and email are stripped of spaces before savign" do
    @user = User.create(name: " John ", email: " johndoe@example.com ")

    assert_equal "John", @user.name
    assert_equal "johndoe@example.com", @user.email
  end
end
