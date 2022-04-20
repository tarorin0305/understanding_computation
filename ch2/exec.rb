require_relative './simple'

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

statement = Assign.new(:x, Add.new(Variable.new(:x), Number.new(1)))
environment = { x: Number.new(2) }
Machine.new(statement, environment).run
