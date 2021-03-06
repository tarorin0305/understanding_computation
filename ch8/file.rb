require 'stringio'

def euclid(x, y)
  until x == y
    if x > y
      x -= y
    else
      y -= x
    end
  end

  x
end

def evaluate(program, input)
  old_stdin = $stdin
  old_stdout = $stdout
  $stdin = StringIO.new(input)
  $stdout = (output = StringIO.new)
  begin
    eval program
  rescue Exception => e
    output.puts(e)
  ensure
    $stdin = old_stdin
    $stdout = old_stdout
  end
  output.string
end

def evaluate_on_itself(program)
  evaluate(program, program)
end
