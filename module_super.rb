class Parent
  def say
    puts "In Parent"
  end
end

module A
  def say
    puts "In A"
    super
  end
end

module B
  def say
    puts "In B"
    super
  end
end

class Parent
  include A, B
  # prepend A, B         # NEW in Ruby 2.0, but not used in Rails yet
end

Parent.new.say
puts Parent.ancestors

###########

class Child < Parent
  include A, B
end

puts Child.ancestors
Child.new.say