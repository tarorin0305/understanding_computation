require_relative './rule'

rulebook = DFARulebook.new([
                             FARule.new(1, 'a', 2), FARule.new(1, 'b', 1),
                             FARule.new(2, 'a', 2), FARule.new(2, 'b', 3),
                             FARule.new(3, 'a', 3), FARule.new(3, 'b', 3)
                           ])
input_string = 'baaaab'
# dfa = DFA.new(1, [3], rulebook); puts "accept?: #{dfa.accepting?}, current_state: #{dfa.current_state}"

# dfa.read_character('b'); puts "accept?: #{dfa.accepting?}, current_state: #{dfa.current_state}"
# 3.times { dfa.read_character('a') }; puts "accept?: #{dfa.accepting?}, current_state: #{dfa.current_state}"
# dfa.read_character('b'); puts "accept?: #{dfa.accepting?}, current_state: #{dfa.current_state}"

# dfa.read_string('baaaa'); puts "accept?: #{dfa.accepting?}, current_state: #{dfa.current_state}"

dfa_dessign = DFADessign.new(1, [3], rulebook)
puts dfa_dessign.accepts?(input_string)
