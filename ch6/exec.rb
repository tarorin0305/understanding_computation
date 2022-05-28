require_relative './proc_caller'
p = ->(n) { n * 2 }
q = ->(x) { p.call(x) }

->(x) { x + 5 }[6]

# p to_integer(ZERO)
# p to_integer(FIVE)
# p to_integer(FIFTEEN)
# p to_integer(HUNDRED)

# my_pair = PAIR[THREE][FIVE] # THREEとFIVEを引数として渡されたラムダ式fを返す。fは、PAIRの第3引数として渡すこともできるが、PAIR[THREE][FIVE]をいったん評価してやりラムダ式の戻り値を得た上で、そのラムダ式の引数としてラムダ式(=f)を渡すことをしている。
# puts '=='
# p LEFT[my_pair]
# p to_integer(LEFT[my_pair])
# p to_integer(RIGHT[my_pair])
# puts '------'
# p to_integer(DECREMENT[FIVE])
# p to_integer(DECREMENT[ZERO])
# p to_boolean(IS_LESS_OR_EQUAL[TWO][TWO])
# p to_boolean(IS_LESS_OR_EQUAL[THREE][TWO])
# p to_integer(MOD[THREE][TWO])
# p to_integer(MOD[
#   POWER[THREE][THREE] ][
#   ADD[THREE][TWO] ])
# my_list = UNSHIFT[
#   UNSHIFT[ UNSHIFT[EMPTY][THREE]
#   ][TWO] ][ONE]
# p to_integer(FIRST[my_list])
# p to_integer(FIRST[REST[REST[my_list]]])
# p to_array(my_list).map { |p| to_integer(p) }
# my_range = RANGE[ONE][FIVE]
# p to_array(my_range).map { |p| to_integer(p) }
# my_list = MAP[RANGE[ONE][FIVE]][INCREMENT]
# p to_array(my_list).map { |p| to_integer(p) }
# p to_char(ZED)
# p to_string(FIZZBUZZ)
# p to_array(TO_DIGITS[FIVE]).map { |p| to_integer(p) }
# p to_array(TO_DIGITS[POWER[FIVE][THREE]]).map { |p| to_integer(p) }
# p to_string(TO_DIGITS[POWER[FIVE][THREE]])

# 実行時間はかかるがちゃんと値を返す
solution = MAP[RANGE[ONE][HUNDRED]][->(n) {
  IF[IS_ZERO[MOD[n][FIFTEEN]]][ FIZZBUZZ
  ][IF[IS_ZERO[MOD[n][THREE]]][ FIZZ
  ][IF[IS_ZERO[MOD[n][FIVE]]][BUZZ][ TO_DIGITS[n]
  ]]]
} ]

to_array(solution).each do |p|
  puts to_string(p)
end; nil
