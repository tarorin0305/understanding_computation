def one(proc, x)
  proc[x]
end

def two(proc, x)
  proc[proc[x]]
end

def three(proc, x)
  proc[proc[proc[x]]]
end

def zero(_proc, x)
  x
end

ZERO = ->(_p) { ->(x) { x } }
FIVE = ->(p) { ->(x) { p[p[p[p[p[x]]]]] } }
FIFTEEN = ->(p) { ->(x) { p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[x]]]]]]]]]]]]]]] } }
HUNDRED = lambda { |p|
  lambda { |x|
    p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[x]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
  }
}
def to_integer(proc)
  proc[->(n) { n + 1 }][0]
end

def true(x, _y)
  x
end

def false(_x, y)
  y
end
TRUE = ->(x) { ->(_y) { x } }
FALSE = ->(_x) { ->(y) { y } }
def to_boolean(proc)
  proc[true][false]
end
to_boolean(TRUE)
# IF =
#   ->(b) {
#     ->(x) {
#       ->(y) {
#         b[x][y]
#       }
#     }
#   }
IF = ->(b) { b }

# ZERO = ->(_p) { ->(x) { x } }
ONE = ->(p) { ->(x) { p[x] } }
TWO = ->(p) { ->(x) { p[p[x]] } }
THREE = ->(p) { ->(x) { p[p[p[x]]] } }

def zero?(proc)
  proc[->(_x) { FALSE }][TRUE]
end
# zero?(ONE)
# ZERO[-> x { FALSE }][TRUE]
# p が [-> x { FALSE }]
# x が TRUE
# TRUE を返す。
# zero?(ONE)
# ONE[-> x { FALSE }][TRUE]
# -> x { FALSE } のx にTRUEを適用したもの
# つまり、 -> x { FALSE } で生成されるラムダ式の引数にTRUEを渡したものが返る。FALSE[TRUE]の実行結果が帰ることになる。これはラムダ式が戻り値となる。
# FALSE は2つの引数を取るラムダ式。
# zero?(TWO) は FALSE[FALSE[TRUE]] を返す

IS_ZERO = ->(n) { n[->(_x) { FALSE }][TRUE] }
to_boolean(IS_ZERO[ZERO])
PAIR = ->(x) { ->(y) { ->(f) { f[x][y] } } }
# 引数pを取るラムダ式。この引数pとしてラムダ式を受け取ることを想定。引数として渡されたラムダ式はcallされる。callの引数と���て、->(x) { ->(_y) { x } } というラムダ式を受け取る。つまり二つの引数を受け取るラムダ式が受理可能。
LEFT = ->(p) { p[->(x) { ->(_y) { x } }] }
RIGHT = ->(p) { p[->(_x) { ->(y) { y } }] }

INCREMENT = ->(n) { ->(p) { ->(x) { p[n[p][x]] } } }
SLIDE = ->(p) { PAIR[RIGHT[p]][INCREMENT[RIGHT[p]]] }
DECREMENT = ->(n) { LEFT[n[SLIDE][PAIR[ZERO][ZERO]]] }

ADD = ->(m) { ->(n) { n[INCREMENT][m] } }
SUBTRACT = ->(m) { ->(n) { n[DECREMENT][m] } }
MULTIPLY = ->(m) { ->(n) { n[ADD[m]][ZERO] } }
POWER = ->(m) { ->(n) { n[MULTIPLY[m]][ONE] } }
IS_LESS_OR_EQUAL = ->(m) {
  ->(n) {
    IS_ZERO[SUBTRACT[m][n]]
  }
}
Z = ->(f) { ->(x) { f[->(y) { x[x][y] }] }[->(x) { f[->(y) { x[x][y] }] }] }

MOD =
  Z[->(f) {
      ->(m) {
        ->(n) {
          IF[IS_LESS_OR_EQUAL[n][m]][
            ->(x) {
              f[SUBTRACT[m][n]][n][x]
            }
          ][ m
          ]
        }
      }
    } ]
EMPTY = PAIR[TRUE][TRUE]
UNSHIFT = ->(l) {
  ->(x) {
    PAIR[FALSE][PAIR[x][l]]
  }
}
IS_EMPTY = LEFT
FIRST = ->(l) { LEFT[RIGHT[l]] }
REST = ->(l) { RIGHT[RIGHT[l]] }
def to_array(proc)
  array = []
  until to_boolean(IS_EMPTY[proc])
    array.push(FIRST[proc])
    proc = REST[proc]
  end
  array
end

RANGE = Z[->(f) {
  ->(m) {
    ->(n) {
      IF[IS_LESS_OR_EQUAL[m][n]][
  ->(x) {
    UNSHIFT[f[INCREMENT[m]][n]][m][x]
  } ][
  EMPTY ]
    }
  }
} ]
FOLD = Z[->(f) {
  ->(l) {
    ->(x) {
      ->(g) {
        IF[IS_EMPTY[l]][
  x ][
  ->(y) {
    g[f[REST[l]][x][g]][FIRST[l]][y]
  } ]
      }
    }
  }
} ]

MAP =
  ->(k) {
    ->(f) {
      FOLD[k][EMPTY][
      ->(l) { ->(x) { UNSHIFT[l][f[x]] } }
      ]
    }
  }
TEN = MULTIPLY[TWO][FIVE]
B = TEN
F = INCREMENT[B]
I = INCREMENT[F]
U = INCREMENT[I]
ZED = INCREMENT[U]
FIZZ = UNSHIFT[UNSHIFT[UNSHIFT[UNSHIFT[EMPTY][ZED]][ZED]][I]][F]
BUZZ = UNSHIFT[UNSHIFT[UNSHIFT[UNSHIFT[EMPTY][ZED]][ZED]][U]][B]
FIZZBUZZ = UNSHIFT[UNSHIFT[UNSHIFT[UNSHIFT[BUZZ][ZED]][ZED]][I]][F]

def to_char(c)
  '0123456789BFiuz'.slice(to_integer(c))
end

def to_string(s)
  to_array(s).map { |c| to_char(c) }.join
end
DIV =
  Z[->(f) {
      ->(m) {
        ->(n) {
          IF[IS_LESS_OR_EQUAL[n][m]][ ->(x) {
                                        INCREMENT[f[SUBTRACT[m][n]][n]][x]
                                      }
          ][ ZERO
          ]
        }
      }
    } ]
PUSH = ->(l) {
  ->(x) {
    FOLD[l][UNSHIFT[EMPTY][x]][UNSHIFT]
  }
}
TO_DIGITS =
  Z[->(f) {
      ->(n) {
        PUSH[
    IF[IS_LESS_OR_EQUAL[n][DECREMENT[TEN]]][
  EMPTY
    ][
  ->(x) {
    f[DIV[n][TEN]][x]
  }
    ]
    ][MOD[n][TEN]]
      }
    } ]
# solution = MAP[RANGE[ONE][HUNDRED]][->(n) {
#   IF[IS_ZERO[MOD[n][FIFTEEN]]][ FIZZBUZZ
#   ][IF[IS_ZERO[MOD[n][THREE]]][ FIZZ
#   ][IF[IS_ZERO[MOD[n][FIVE]]][BUZZ][ TO_DIGITS[n]
#   ]]]
# } ]
