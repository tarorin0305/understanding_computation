require_relative './rule'
module Pattern
  def bracket(outer_precedence)
    # precedence の意味 優先度 https://www.techopedia.com/definition/3859/precedence-c
    # 自身が持つ優先度数値より、引数に渡された優先度数値が大きい場合、自身を括弧で囲む。抽象構文木を表示するために用いるメソッド
    if precedence < outer_precedence
      '(' + to_s + ')'
    else
      to_s
    end
  end

  def inspect
    "/#{self}/"
  end

  # NFAのインスタンスを生成し、このNFAが入力文字列を受理するか判定する
  def matches?(string)
    to_nfa_design.accepts?(string)
  end
end

# このファイルでは構文クラスを定義している
class Empty
  include Pattern

  def to_s
    ''
  end

  def precedence
    3
  end

  # 構文クラスのインスタンスと、NFAとを対応づけるメソッド
  def to_nfa_design
    start_state = Object.new
    # この構文クラスが受理できる状態を定義している
    accept_states = [start_state]
    rulebook = NFARulebook.new([])

    # 開始状態、受理状態、規則集を渡してNFAを生成する
    # 開始状態と受理状態を同じにしている
    NFADesgin.new(start_state, accept_states, rulebook)
  end
end

class Literal < Struct.new(:character)
  include Pattern

  def to_s
    character
  end

  def precedence
    3
  end

  def to_nfa_design
    start_state = Object.new
    accept_state = Object.new
    # 引数characterを読み込むと、start_stateからaccept_stateへ移動する規則を生成する
    rule = FARule.new(start_state, character, accept_state) # 開始状態start_stateの状態でcharacterを読み込むと、accept_stateに遷移するに遷移するオートマトンをnewしている
    rulebook = NFARulebook.new([rule])

    # 上で生成した規則集を用いて、FAが遷移先とする状態を受理状態として受け取るオートマトンをnewしている
    # つまり、このLiteralインスタンス生成時に渡されたcharacterと、NFADesginのインスタンスメソッドaccepts?に渡す文字が一致するならば、上記規則に基づきaccept_stateへとオートマトンは遷移し、current_statesにaccept_statesが代入される。その状態でNFA#accepting？を判定する
    NFADesgin.new(start_state, [accept_state], rulebook)
  end
end

class Concatenate < Struct.new(:first, :second)
  include Pattern

  def to_s
    [first, second].map { |pattern| pattern.bracket(precedence) }.join
  end

  def precedence
    1
  end

  def to_nfa_design
    first_nfa_design = first.to_nfa_design
    second_nfa_design = second.to_nfa_design

    start_state = first_nfa_design.start_state
    accept_states = second_nfa_design.accept_states
    rules = first_nfa_design.rulebook.rules + second_nfa_design.rulebook.rules
    # 1 番目の NFA の元の受理状態をそれぞれ 2 番目の NFA の元の開始状態につなげるための追加の自由移動
    extra_rules = first_nfa_design.accept_states.map do |state|
      FARule.new(state, nil, second_nfa_design.start_state)
    end

    rulebook = NFARulebook.new(rules + extra_rules)
    NFADesgin.new(start_state, accept_states, rulebook)
  end
end

class Choose < Struct.new(:first, :second)
  include Pattern

  def to_s
    [first, second].map { |pattern| pattern.bracket(precedence) }.join('|')
  end

  def precedence
    0
  end

  def to_nfa_design
    first_nfa_design = first.to_nfa_design
    second_nfa_design = second.to_nfa_design

    start_state = Object.new
    accept_states = first_nfa_design.accept_states + second_nfa_design.accept_states
    rules = first_nfa_design.rulebook.rules + second_nfa_design.rulebook.rules
    extra_rules = [first_nfa_design, second_nfa_design].map do |nfa_design|
      FARule.new(start_state, nil, nfa_design.start_state)
    end
    rulebook = NFARulebook.new(rules + extra_rules)

    NFADesgin.new(start_state, accept_states, rulebook)
  end
end

class Repeat < Struct.new(:pattern)
  include Pattern

  def to_s
    pattern.bracket(precedence) + '*'
  end

  def precedence
    2
  end

  def to_nfa_design
    pattern_nfa_design = pattern.to_nfa_design

    start_state = Object.new
    accept_states = pattern_nfa_design.accept_states + [start_state]
    rules = pattern_nfa_design.rulebook.rules
    extra_rules =
      pattern_nfa_design.accept_states.map do |accept_state|
        FARule.new(accept_state, nil, pattern_nfa_design.start_state)
      end + [FARule.new(start_state, nil, pattern_nfa_design.start_state)]
    rulebook = NFARulebook.new(rules + extra_rules)

    NFADesgin.new(start_state, accept_states, rulebook)
  end
end
