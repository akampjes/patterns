require File.dirname(__FILE__) + '/test_helper'
require "active_record"
require "relation"

class RelationTest < Test::Unit::TestCase
  def setup
    @relation = ActiveRecord::Relation.new(User)
  end

  def test_where
    relation = @relation.where("name = 'Marc'")
    assert_equal "SELECT * FROM users WHERE name = 'Marc'", relation.to_sql
    assert_equal "SELECT * FROM users WHERE name = 'Marc' AND id = 1", relation.where("id = 1").to_sql
    # Demo: Inverse order of two prev lines. This is why we need to clone.
  end

  def test_to_a
    user = @relation.where("id = 1").to_a.first
    assert_equal 1, user.id
  end

  def test_proxy_methods_to_a
    user = @relation.where("id = 1").first
    assert_equal 1, user.id
  end
  
  def test_proxy_methods_from_class
    user = User.where("id = 1").first
    assert_equal 1, user.id
  end
end