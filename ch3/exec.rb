require_relative './rule'
require_relative './regular'

# rulebook = DFARulebook.new([
#                              FARule.new(1, 'a', 2), FARule.new(1, 'b', 1),
#                              FARule.new(2, 'a', 2), FARule.new(2, 'b', 3),
#                              FARule.new(3, 'a', 3), FARule.new(3, 'b', 3)
#                            ])
# input_string = 'baaaab'
# dfa = DFA.new(1, [3], rulebook); puts "accept?: #{dfa.accepting?}, current_state: #{dfa.current_state}"

# dfa.read_character('b'); puts "accept?: #{dfa.accepting?}, current_state: #{dfa.current_state}"
# 3.times { dfa.read_character('a') }; puts "accept?: #{dfa.accepting?}, current_state: #{dfa.current_state}"
# dfa.read_character('b'); puts "accept?: #{dfa.accepting?}, current_state: #{dfa.current_state}"

# dfa.read_string('baaaa'); puts "accept?: #{dfa.accepting?}, current_state: #{dfa.current_state}"

# dfa_dessign = DFADessign.new(1, [3], rulebook)
# puts dfa_dessign.accepts?(input_string)

# rulebook = NFARulebook.new([
#                              FARule.new(1, 'a', 1), FARule.new(1, 'b', 1), FARule.new(1, 'b', 2),
#                              FARule.new(2, 'a', 3), FARule.new(2, 'b', 3),
#                              FARule.new(3, 'a', 4), FARule.new(3, 'b', 4)
#                            ])

# p rulebook.next_states(Set[1], 'b')
# p rulebook.next_states(Set[1, 2], 'a')
# p rulebook.next_states(Set[1, 3], 'b')
# p NFA.new(Set[1], [4], rulebook).accepting?

# nfa = NFA.new(Set[1], [4], rulebook); p nfa.accepting?
# nfa.read_character('b'); p nfa.accepting?
# nfa.read_character('a'); p nfa.accepting?
# nfa.read_character('b'); p nfa.accepting?
# nfa = NFA.new(Set[1], [4], rulebook); p nfa.accepting?
# nfa.read_string('bbbbb'); p nfa.accepting?

# nfa_design = NFADesgin.new(1, [4], rulebook)
# p nfa_design.accepts?('bab')
# p nfa_design.accepts?('bbabb')

# rulebook = NFARulebook.new([
#                              FARule.new(1, nil, 2), FARule.new(1, nil, 4),
#                              FARule.new(2, 'a', 3),
#                              FARule.new(3, 'a', 2),
#                              FARule.new(4, 'a', 5),
#                              FARule.new(5, 'a', 6),
#                              FARule.new(6, 'a', 4)
#                            ])
# rulebook.next_states(Set[1], nil)

# pattern = Repeat.new(
#   Choose.new(
#     Concatenate.new(Literal.new('a'), Literal.new('b')),
#     Literal.new('a')
#   )
# )
# p pattern

# nfa_design = Empty.new.to_nfa_design
# p nfa_design.accepts?('')

# p Empty.new.matches?('a')
# p Empty.new.matches?('')
# p Literal.new('a').matches?('a')
# p Literal.new('a').matches?('')

# pattern = Concatenate.new(Literal.new('a'), Literal.new('b'))
# p pattern
# p pattern.matches?('a')
# p pattern.matches?('ab')
# p pattern.matches?('abc')

# pattern = Repeat.new(
#   Choose.new(
#     Concatenate.new(Literal.new('a'), Literal.new('b')),
#     Literal.new('a')
#   )
# )
# p pattern
nfa_design = Empty.new.to_nfa_design
nfa_design.accepts?('')
