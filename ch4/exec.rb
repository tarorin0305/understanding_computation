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
# rule.follow(configuration)
# rule.applies_to?(configuration, '(')

# stack = Stack.new(['$']).push('x').push('y').push('z')

# rulebook = DPDARulebook.new([
#                               PDARule.new(1, '(', 2, '$', ['b', '$']),
#                               PDARule.new(2, '(', 2, 'b', %w[b b]),
#                               PDARule.new(2, ')', 2, 'b', []),
#                               PDARule.new(2, nil, 1, '$', ['$'])
#                             ])
# configuration = rulebook.next_configuration(configuration, '(')
# configuration = rulebook.next_configuration(configuration, '(')
# configuration = rulebook.next_configuration(configuration, ')')

# dpda = DPDA.new(PDAConfiguration.new(1, Stack.new(['$'])), [1], rulebook)
# dpda.read_string('(()'); dpda.current_configuration
# p dpda.accepting?
# p dpda.stuck?

# dpda_design = DPDADesign.new(1, '$', [1], rulebook)
# dpda_design.accepts?('(((((((((())))))))))')

# rulebook = DPDARulebook.new([
#                               PDARule.new(1, 'a', 2, '$', ['a', '$']),
#                               PDARule.new(1, 'b', 2, '$', ['b', '$']),
#                               PDARule.new(2, 'a', 2, 'a', %w[a a]),
#                               PDARule.new(2, 'b', 2, 'b', %w[b b]),
#                               PDARule.new(2, 'a', 2, 'b', []),
#                               PDARule.new(2, 'b', 2, 'a', []),
#                               PDARule.new(2, nil, 1, '$', ['$'])
#                             ])
# dpda_design = DPDADesign.new(1, '$', [1], rulebook)
# dpda_design.accepts?('ababab')

rulebook = NPDARulebook.new([
                              PDARule.new(1, 'a', 1, '$', ['a', '$']),
                              PDARule.new(1, 'a', 1, 'a', %w[a a]),
                              PDARule.new(1, 'a', 1, 'b', %w[a b]),
                              PDARule.new(1, 'b', 1, '$', ['b', '$']),
                              PDARule.new(1, 'b', 1, 'a', %w[b a]),
                              PDARule.new(1, 'b', 1, 'b', %w[b b]),
                              PDARule.new(1, nil, 2, '$', ['$']),
                              PDARule.new(1, nil, 2, 'a', ['a']),
                              PDARule.new(1, nil, 2, 'b', ['b']),
                              PDARule.new(2, 'a', 2, 'a', []),
                              PDARule.new(2, 'b', 2, 'b', []),
                              PDARule.new(2, nil, 3, '$', ['$'])
                            ])
npda_design = NPDADesign.new(1, '$', [3], rulebook)
p npda_design.accepts?('abba')
p npda_design.accepts?('baabaa')
