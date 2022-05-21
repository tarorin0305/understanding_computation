require_relative './analyzer'
require_relative './machine'
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
# p npda_design.accepts?('abba')
# p npda_design.accepts?('baabaa')
# p LexicalAnalyzer.new('y = x * 7').analyze
# p LexicalAnalyzer.new('if (x < 10) { y = true; x = 0 } else { do-nothing }').analyze
# p LexicalAnalyzer.new('x = falsehood').analyze

start_rule = PDARule.new(1, nil, 2, '$', ['S', '$'])
symbol_rules = [
  # <statement> ::= <while> | <assign>
  PDARule.new(2, nil, 2, 'S', ['W']),
  PDARule.new(2, nil, 2, 'S', ['A']),

  # <while> ::= 'w' '(' <expression> ')' '{' <statement> '}'
  PDARule.new(2, nil, 2, 'W', ['w', '(', 'E', ')', '{', 'S', '}']),

  # <assign> ::= 'v' '=' <expression>
  PDARule.new(2, nil, 2, 'A', ['v', '=', 'E']),

  # <expression> ::= <less-than>
  PDARule.new(2, nil, 2, 'E', ['L']),

  # <less-than> ::= <multiply> '<' <less-than> | <multiply>
  PDARule.new(2, nil, 2, 'L', ['M', '<', 'L']),
  PDARule.new(2, nil, 2, 'L', ['M']),

  # <multiply> ::= <term> '*' <multiply> | <term>
  PDARule.new(2, nil, 2, 'M', ['T', '*', 'M']),
  PDARule.new(2, nil, 2, 'M', ['T']),

  # <term> ::= 'n' | 'v'
  PDARule.new(2, nil, 2, 'T', ['n']),
  PDARule.new(2, nil, 2, 'T', ['v'])
]

token_rules = LexicalAnalyzer::GRAMMAR.map do |rule|
  PDARule.new(2, rule[:token], 2, rule[:token], [])
end
# token_rules は下記のようなPDARuleの集合を作っている
# 2, "i", 2, "i", []
# 2, "e", 2, "e", []
# 2, "w", 2, "w", []
# 2, "d", 2, "d", []
# 2, "(", 2, "(", []
# 2, ")", 2, ")", []
# 2, "{", 2, "{", []
# 2, "}", 2, "}", []
# 2, ";", 2, ";", []
# 2, "=", 2, "=", []
# 2, "+", 2, "+", []
# 2, "*", 2, "*", []
# 2, "<", 2, "<", []
# 2, "n", 2, "n", []
# 2, "b", 2, "b", []
# 2, "v", 2, "v", []
# puts token_rules
# stop_rule = PDARule.new(2, nil, 3, '$', ['$'])
# rulebook = NPDARulebook.new([start_rule, stop_rule] + symbol_rules + token_rules)
# npda_design = NPDADesign.new(1, '$', [3], rulebook)
# token_string = LexicalAnalyzer.new('while (x < 5) { x = x * 3 }').analyze.join
# p token_string
# p npda_design.accepts?(token_string)

tape = Tape.new(%w[1 0 1], '1', [], '_')
p tape.middle
p tape.move_head_left
rule = TMRule.new(1, '0', 2, '1', :right)
p rule.applies_to?(TMConfiguration.new(1, Tape.new([], '0', [], '_')))
p rule.applies_to?(TMConfiguration.new(1, Tape.new([], '1', [], '_')))
p rule.follow(TMConfiguration.new(1, Tape.new([], '0', [], '_')))
rulebook = DTMRulebook.new([
                             TMRule.new(1, '0', 2, '1', :right),
                             TMRule.new(1, '1', 1, '0', :left),
                             TMRule.new(1, '_', 2, '1', :right),
                             TMRule.new(2, '0', 2, '0', :right),
                             TMRule.new(2, '1', 2, '1', :right),
                             TMRule.new(2, '_', 3, '_', :left)
                           ])
configuration = TMConfiguration.new(1, tape)
p configuration
configuration = rulebook.next_configuration(configuration)
p configuration
dtm = DTM.new(TMConfiguration.new(1, tape), [3], rulebook)
dtm.run
p dtm.accepting?
tape = Tape.new(%w[1 2 1], '1', [], '_')
dtm = DTM.new(TMConfiguration.new(1, tape), [3], rulebook)
dtm.run
p dtm.stuck?
