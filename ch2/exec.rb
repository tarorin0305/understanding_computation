require_relative './simple'
# require_relative './big_step'

# Add.new(
#   Multiply.new(Number.new(1), Number.new(2)),
#   Multiply.new(Number.new(3), Number.new(4))
# )

# p Number.new(1).reducible?
# p Add.new(Number.new(1), Number.new(2)).reducible?

# p expression
# p expression.reducible?
# expression = expression.reduce
# p expression
# p expression.reducible?
# expression = expression.reduce
# p expression
# p expression.reducible?
# expression = expression.reduce
# p expression
# p expression.reducible?

# expression = Add.new(
#   Multiply.new(Number.new(1), Number.new(2)),
#   Multiply.new(Number.new(3), Number.new(4))
# )

# Machine.new(expression).run
# Machine.new(LessThan.new(
#   Number.new(5),
#   Add.new(Number.new(2), Number.new(2))
# )).run

# Machine.new(
#   Add.new(Variable.new(:x), Variable.new(:y)),
#   { x: Number.new(3), y: Number.new(4) }
# ).run

# statement = Assign.new(:x, Add.new(Variable.new(:x), Number.new(1)))
# environment = { x: Number.new(2) }
# Machine.new(statement, environment).run

# Machine.new(
#   If.new(
#     Variable.new(:x),
#     Assign.new(:y, Number.new(1)),
#     Assign.new(:y, Number.new(2))
#   ),
#   { x: Boolean.new(true) }
# ).run

# Machine.new(
#   Sequence.new(
#     Assign.new(:x, Add.new(Number.new(1), Number.new(1))),
#     Assign.new(:y, Add.new(Variable.new(:x), Number.new(3)))
#   ),
#   {}
# ).run

# Machine.new(
#   While.new(
#     LessThan.new(Variable.new(:x), Number.new(5)),
#     Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3)))
#   ),
#   { x: Number.new(1) }
# ).run
# p LessThan.new(
#   Add.new(Variable.new(:x), Number.new(2)),
#   Variable.new(:y)
# ).evaluate({ x: Number.new(2), y: Number.new(5) })

# statement = While.new(
#   LessThan.new(Variable.new(:x), Number.new(5)),
#   Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3)))
# )
# p statement
# p statement.evaluate({ x: Number.new(1) })

# str = Number.new(5).to_ruby
# proc = eval(str)
# p proc
# p proc.call({})

# expression = Variable.new(:x)
# p expression
# p expression.to_ruby
# proc = eval(expression.to_ruby)
# p proc
# p proc.call({ x: 7 })

# p Add.new(Variable.new(:x), Number.new(1)).to_ruby
# p LessThan.new(Variable.new(:x), Number.new(5)).to_ruby

# environment = { x: 3 }
# proc = eval(Add.new(Variable.new(:x), Number.new(1)).to_ruby)
# p proc.call(environment)

# statement = Assign.new(:y, Add.new(Variable.new(:x), Number.new(1)))
# p statement
# p statement.to_ruby
# proc = eval(statement.to_ruby)
# p proc
# p proc.call({ x: 3 })

statement =
  While.new(
    LessThan.new(Variable.new(:x), Number.new(5)),
    Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3)))
  )
p statement
p statement.to_ruby
proc = eval(statement.to_ruby)
p proc
p proc.call({ x: 1 })
