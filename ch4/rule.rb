require 'set'

# 現在のstate, 入力文字, 遷移先のstate の3つの情報で構成されるのが1つの規則
class FARule < Struct.new(:state, :character, :next_state)
  def applies_to?(state, character)
    self.state == state && self.character == character
  end

  def follow
    next_state
  end

  def inspect
    "#<FARule #{state.inspect} --#{character}--> #{next_state.inspect}>"
  end
end

class DFARulebook < Struct.new(:rules)
  def next_state(state, character)
    rule_for(state, character).follow
  end

  def rule_for(state, character)
    rules.detect { |rule| rule.applies_to?(state, character) }
  end
end

class DFA < Struct.new(:current_state, :accept_states, :rulebook)
  def accepting?
    accept_states.include?(current_state)
  end

  def read_character(character)
    self.current_state = rulebook.next_state(current_state, character)
  end

  def read_string(string)
    string.chars.each do |character|
      read_character(character)
    end
  end
end

class DFADessign < Struct.new(:start_state, :accept_states, :rulebook)
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

# スタックというデータ構造と操作を実装している
class Stack < Struct.new(:contents)
  def push(character)
    Stack.new([character] + contents)
  end

  def pop
    Stack.new(contents.drop(1))
  end

  def top
    contents.first
  end

  def inspect
    "<Stack (#{top}) #{contents.drop(1).join}>"
  end
end

class PDAConfiguration < Struct.new(:state, :stack)
  STUCK_STATE = Object.new
  def stuck
    PDAConfiguration.new(STUCK_STATE, stack)
  end

  def stuck?
    state == STUCK_STATE
  end
end

# FARuleでは扱ってなかった、ポップする文字とプッシュする文字を規則が持つようになっている
class PDARule < Struct.new(:state, :character, :next_state, :pop_character, :push_characters)
  # 構成として渡された状態とスタックに対応する規則であるか判定
  def applies_to?(configuration, character)
    state == configuration.state && # state比較
      pop_character == configuration.stack.top && # 渡された構成のスタックのトップと、ポップで取り出すことになっている規則であるかを比較
      self.character == character # 入力されたcharacterと規則が対応可能なcharacterとの比較
  end

  # 新たな構成を返す
  def follow(configuration)
    PDAConfiguration.new(next_state, next_stack(configuration))
  end

  # 現在のスタックをポップしたあと、pushする文字をスタックに追加する。スタックとしてのArrayを返す
  def next_stack(configuration)
    popped_stack = configuration.stack.pop
    push_characters.reverse.inject(popped_stack) { |stack, character| stack.push(character) }
  end
end

class DPDARulebook < Struct.new(:rules)
  def next_configuration(configuration, character)
    rule_for(configuration, character).follow(configuration)
  end

  def rule_for(configuration, character)
    rules.detect { |rule| rule.applies_to?(configuration, character) }
  end

  def applies_to?(configuration, character)
    !rule_for(configuration, character).nil?
  end

  def follow_free_moves(configuration)
    if applies_to?(configuration, nil)
      follow_free_moves(next_configuration(configuration, nil))
    else
      configuration
    end
  end
end

class DPDA < Struct.new(:current_configuration, :accept_states, :rulebook)
  def next_configuration(character)
    if rulebook.applies_to?(current_configuration, character)
      rulebook.next_configuration(current_configuration, character)
    else
      current_configuration.stuck
    end
  end

  def stuck?
    current_configuration.stuck?
  end

  def accepting?
    accept_states.include?(current_configuration.state)
  end

  # 入力文字を読み込むことで、現在の構成を変更させる副作用を担う
  def read_character(character)
    self.current_configuration =
      next_configuration(character)
  end

  def read_string(string)
    string.chars.each do |character|
      read_character(character) unless stuck?
    end
  end

  def current_configuration
    rulebook.follow_free_moves(super)
  end
end

class DPDADesign < Struct.new(:start_state, :bottom_character, :accept_states, :rulebook)
  def accepts?(string)
    to_dpda.tap { |dpda| dpda.read_string(string) }.accepting?
  end

  def to_dpda
    start_stack = Stack.new([bottom_character])
    start_configuration = PDAConfiguration.new(start_state, start_stack)
    DPDA.new(start_configuration, accept_states, rulebook)
  end
end

class NPDARulebook < Struct.new(:rules)
  def next_configurations(configurations, character)
    configurations.flat_map { |configuration| follow_rules_for(configuration, character) }.to_set
  end

  def follow_rules_for(configuration, character)
    rules_for(configuration, character).map { |rule| rule.follow(configuration) }
  end

  def rules_for(configuration, character)
    rules.select { |rule| rule.applies_to?(configuration, character) }
  end

  def follow_free_moves(configurations)
    more_configurations = next_configurations(configurations, nil)
    if more_configurations.subset?(configurations)
      configurations
    else
      follow_free_moves(configurations + more_configurations)
    end
  end
end

class NPDA < Struct.new(:current_configurations, :accept_states, :rulebook)
  def accepting?
    current_configurations.any? { |configuration| accept_states.include?(configuration.state) }
  end

  def read_character(character)
    self.current_configurations =
      rulebook.next_configurations(current_configurations, character)
  end

  def read_string(string)
    string.chars.each do |character|
      read_character(character)
    end
  end

  def current_configurations
    rulebook.follow_free_moves(super)
  end
end

class NPDADesign < Struct.new(:start_state, :bottom_character, :accept_states, :rulebook)
  def accepts?(string)
    to_npda.tap { |npda| npda.read_string(string) }.accepting?
  end

  def to_npda
    start_stack = Stack.new([bottom_character])
    start_configuration = PDAConfiguration.new(start_state, start_stack)
    NPDA.new(Set[start_configuration], accept_states, rulebook)
  end
end
