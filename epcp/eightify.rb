#!/usr/bin/ruby

class Eightify
  def process(list)
    return list
  end
end

if $0 == __FILE__
  # direct call

  lines = File.open(ARGV[0]).readlines.map {|x| x.chomp}

  e = Eightify.new
  newlines = e.process lines
  puts newlines.join("\n")

end
