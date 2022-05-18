require 'set'

# 現在のstate, 入力文字, 遷移先のstate の3つの情報で構成されるのが1つの規則
# 規則を表現している。規則は関数
class FARule < Struct.new(:state, :character, :next_state)
  # オートマトンの現在の状態と、読み取った入力文字のペアに対して自身が適用可能な規則(＝関数)であるかを判定する
  # FARuleは、stateとcharacterのペアを1組のみ持つ
  def applies_to?(state, character)
    self.state == state && self.character == character
  end

  # 規則自身は、自分が応答可能な状態＆入力のペアを渡された際に、どの状態に遷移するかという情報をもっている。それがnext_stateというプロパティ。このメソッドではそのプロパティの値を返している
  def follow
    next_state
  end

  def inspect
    "#<FARule #{state.inspect} --#{character}--> #{next_state.inspect}>"
  end
end

# 規則を要素とする集合を表現している。規則集。
class DFARulebook < Struct.new(:rules)
  # 規則集のインスタンスは、現在の状態と入力された文字を受け取り、応答可能なただ一つの規則を探し出す。探索後、followmethodを呼び出して、その規則による応答を返す
  def next_state(state, character)
    rule_for(state, character).follow
  end

  # 応答可能な規則の探索を行う
  def rule_for(state, character)
    rules.detect { |rule| rule.applies_to?(state, character) }
  end
end

# 状態を保持するオートマトンを表現するクラス
# この決定性有限オートマトンは規則集と、現在の状態と、受理状態集合をプロパティとして持つ
class DFA < Struct.new(:current_state, :accept_states, :rulebook)
  # 現在状態が受理状態集合に含まれているかどうかを判定する
  def accepting?
    accept_states.include?(current_state)
  end

  # オートマトンが読み込んだ文字と現在状態のペアに対して、規則集が応答する次の状態を返す関数
  # 値を返すだけでなく、オートマトンが保持する現在状態の変更という副作用を持つ
  def read_character(character)
    self.current_state = rulebook.next_state(current_state, character)
  end

  def read_string(string)
    string.chars.each do |character|
      read_character(character)
    end
  end
end

# 手動でいちいちオートマトンのインスタンスを生成しなくて済むように、インスタンス生成を内部で行なってくれる製造機クラスを表現している
class DFADessign < Struct.new(:start_state, :accept_states, :rulebook)
  # 使い捨てオートマトンを生成
  def to_dfa
    DFA.new(start_state, accept_states, rulebook)
  end

  def accepts?(string)
    to_dfa.tap { |dfa| dfa.read_string(string) }.accepting?
  end
end

class NFARulebook < Struct.new(:rules)
  # 現時点でとりうる状態のリストを渡す
  def next_states(states, character)
    states.flat_map { |state| follow_rules_for(state, character) }.to_set
  end

  def follow_rules_for(state, character)
    rules_for(state, character).map(&:follow)
  end

  def rules_for(state, character)
    rules.select { |rule| rule.applies_to?(state, character) } # detectではなくselectになっているのがDFAとの違い
  end

  def follow_free_moves(states)
    more_states = next_states(states, nil) # nilを入力に渡すと遷移できる、自由移動後の状態のリストを返す

    # 現在状態のリストを引数としているので、現在状態のリストが自由移動後の状態のリストを包含している場合は、現在の状態のリストを返す
    if more_states.subset?(states)
      states
    else
      follow_free_moves(states + more_states)
    end
  end

  def alphabet
    rules.map(&:character).compact.uniq
  end
end

class NFA < Struct.new(:current_states, :accept_states, :rulebook)
  def accepting?
    (current_states & accept_states).any?
  end

  def read_character(character)
    self.current_states = rulebook.next_states(current_states, character)
  end

  def read_string(string)
    string.chars.each do |character|
      read_character(character)
    end
  end

  def current_states
    rulebook.follow_free_moves(super)
  end
end

class NFADesgin < Struct.new(:start_state, :accept_states, :rulebook)
  def accepts?(string)
    to_nfa.tap { |nfa| nfa.read_string(string) }.accepting?
  end

  def to_nfa(current_states = Set[start_state])
    NFA.new(current_states, accept_states, rulebook)
  end
end

class NFASimulation < Struct.new(:nfa_design)
  def next_state(state, character)
    nfa_design.to_nfa(state).tap do |nfa|
      nfa.read_character(character)
    end.current_states
  end

  def rules_for(state)
    nfa_design.rulebook.alphabet.map do |character|
      FARule.new(state, character, next_state(state, character))
    end
  end

  def discover_states_and_rules(states)
    rules = states.flat_map { |state| rules_for(state) }
    more_states = rules.map(&:follow).to_set
    if more_states.subset?(states)
      [states, rules]
    else
      discover_states_and_rules(states + more_states)
    end
  end

  def to_dfa_design
    start_state = nfa_design.to_nfa.current_states
    states, rules = discover_states_and_rules(Set[start_state])
    accept_states = states.select { |state| nfa_design.to_nfa(state).accepting? }
    DFADesign.new(start_state, accept_states, DFARulebook.new(rules))
  end
end
