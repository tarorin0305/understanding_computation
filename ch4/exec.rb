require_relative './regular'
# rulebook = NFARulebook.new([
#                              FARule.new(0, '(', 1), FARule.new(1, ')', 0),
#                              FARule.new(1, '(', 2), FARule.new(2, ')', 1),
#                              FARule.new(2, '(', 3), FARule.new(3, ')', 2)
#                            ])
# # p rulebook
# # nfa_design = NFADesgin.new(0, [0], rulebook)
# # p nfa_design
# # p nfa_design.accepts?('(())')
# # p nfa_design.accepts?('((())')

# stack = Stack.new(['a', 'b', 'c', 'd', 'e'])
# p stack
# p stack.top
# rule = PDARule.new(1, '(', 2, '$', ['b', '$'])
# configuration = PDAConfiguration.new(1, Stack.new(['$']))
# p rule.applies_to?(configuration, '(')

# stack = Stack.new(['$']).push('x').push('y').push('z')
# p stack
rulebook = DPDARulebook.new([
                              PDARule.new(1, '(', 2, '$', ['b', '$']),
                              PDARule.new(2, '(', 2, 'b', %w[b b]),
                              PDARule.new(2, ')', 2, 'b', []),
                              PDARule.new(2, nil, 1, '$', ['$'])
                            ])
dpda = DPDA.new(PDAConfiguration.new(1, Stack.new(['$'])), [1], rulebook)
dpda.read_string('())'); dpda.current_configuration
p dpda.accepting?
p dpda.stuck?
