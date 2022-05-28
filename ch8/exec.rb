require_relative './file'
# require_relative './tape'
# require_relative './combinater'
# p = ->(n) { n * 2 }
# q = ->(x) { p.call(x) }

# ->(x) { x + 5 }[6]

# # p to_integer(ZERO)
# # p to_integer(FIVE)
# # p to_integer(FIFTEEN)
# # p to_integer(HUNDRED)

# # my_pair = PAIR[THREE][FIVE] # THREEとFIVEを引数として渡されたラムダ式fを返す。fは、PAIRの第3引数として渡すこともできるが、PAIR[THREE][FIVE]をいったん評価してやりラムダ式の戻り値を得た上で、そのラムダ式の引数としてラムダ式(=f)を渡すことをしている。
# # puts '=='
# # p LEFT[my_pair]
# # p to_integer(LEFT[my_pair])
# # p to_integer(RIGHT[my_pair])
# # puts '------'
# # p to_integer(DECREMENT[FIVE])
# # p to_integer(DECREMENT[ZERO])
# # p to_boolean(IS_LESS_OR_EQUAL[TWO][TWO])
# # p to_boolean(IS_LESS_OR_EQUAL[THREE][TWO])
# # p to_integer(MOD[THREE][TWO])
# # p to_integer(MOD[
# #   POWER[THREE][THREE] ][
# #   ADD[THREE][TWO] ])
# # my_list = UNSHIFT[
# #   UNSHIFT[ UNSHIFT[EMPTY][THREE]
# #   ][TWO] ][ONE]
# # p to_integer(FIRST[my_list])
# # p to_integer(FIRST[REST[REST[my_list]]])
# # p to_array(my_list).map { |p| to_integer(p) }
# # my_range = RANGE[ONE][FIVE]
# # p to_array(my_range).map { |p| to_integer(p) }
# # my_list = MAP[RANGE[ONE][FIVE]][INCREMENT]
# # p to_array(my_list).map { |p| to_integer(p) }
# # p to_char(ZED)
# # p to_string(FIZZBUZZ)
# # p to_array(TO_DIGITS[FIVE]).map { |p| to_integer(p) }
# # p to_array(TO_DIGITS[POWER[FIVE][THREE]]).map { |p| to_integer(p) }
# # p to_string(TO_DIGITS[POWER[FIVE][THREE]])

# # 実行時間はかかるがちゃんと値を返す
# # solution = MAP[RANGE[ONE][HUNDRED]][->(n) {
# #   IF[IS_ZERO[MOD[n][FIFTEEN]]][ FIZZBUZZ
# #   ][IF[IS_ZERO[MOD[n][THREE]]][ FIZZ
# #   ][IF[IS_ZERO[MOD[n][FIVE]]][BUZZ][ TO_DIGITS[n]
# #   ]]]
# # } ]

# # to_array(solution).each do |p|
# #   puts to_string(p)
# # end; nil

# current_tape = TAPE[EMPTY][ZERO][EMPTY][ZERO]
# current_tape = TAPE_WRITE[current_tape][ONE]
# current_tape = TAPE_MOVE_HEAD_RIGHT[current_tape]
# current_tape = TAPE_WRITE[current_tape][TWO]
# current_tape = TAPE_MOVE_HEAD_RIGHT[current_tape]
# current_tape = TAPE_WRITE[current_tape][THREE]
# current_tape = TAPE_MOVE_HEAD_RIGHT[current_tape]
# p to_array(TAPE_LEFT[current_tape]).map { |p| to_integer(p) }
# p to_integer(TAPE_MIDDLE[current_tape])
# p to_array(TAPE_RIGHT[current_tape]).map { |p| to_integer(p) }
# p add(two, three)
# x = SKISymbol.new(:x)
# expression = SKICall.new(SKICall.new(S, K), SKICall.new(I, x))
# p expression
# y = SKISymbol.new(:y)
# z = SKISymbol.new(:z)
# p S.call(x, y, z)

program = "puts 'hello world'"
bytes_in_binary = program.bytes.map { |b| b.to_s(2).rjust(8, '0') }
number = bytes_in_binary.join.to_i(2)
bytes_in_binary = number.to_s(2).scan(/.+?(?=.{8}*\z)/)
program = bytes_in_binary.map { |string| string.to_i(2).chr }.join
eval program
evaluate_on_itself('print $stdin.read.reverse')
