#!/usr/bin/ruby

class Eightify
  @@patterns = {
      /^.*[sS](\d+)[eE](\d+).*$/ => '\1\2',
      /^.*(\d+)[xX](\d+).*$/ => '\1\2',
      /^.*(\d+).(\d+).*$/ => '\1\2',
      /^.*(\d+)..(\d+).*$/ => '\1\2',
      /^.*(\d{3,}).*$/ => '\1'
    }
  
  def initialize
    @debug = false
  end
  
  def dp(string)
    puts string if @debug
  end
  
  def commons(list)
    list = list.map {|filename|  filename.gsub(/\.[^.]+$/, '') }
    
    string = list.join(" ")
    counts = wordcount string.split
    pairs = []
    counts.each { |word,count| pairs.push [word,count] if count > 1 }
    counts.sort {|pair1, pair2| pair2[1] <=> pair1[1]}
  end
  
  def wordcount(words)
    counts = {}
    words = words.sort.map { |word| 
      counts[word] ||= 0
      counts[word] += 1
    }
    dp "counts is #{counts}"
    counts
  end
  
  def reduce(word, size=4)
    return word if word.length <= size
    
    word = word.gsub(/[^a-zA-Z0-9]/, '')
    return word if word.length <= size
    dp "reduced is #{word}"

    word = word.gsub(/[aeiouyAEIOUY]/, '')
    return word if word.length <= size
    dp "reduced is #{word}"

    return word[0..size-1]
  end
  
  def getbase(list, maxsize=4)
    commons = commons list
    words = commons.map {|pair| pair[0] }
    word = reduce words[0], maxsize
    word
  end

  def getnums(list)
    good = nil
    @@patterns.each {|pattern, result|
      extracted = list.map {|string| 
        if string.match(pattern)
          string.sub(pattern, result) 
        else
          "nomatch"
        end
      }
      dp "extracted is #{extracted}"
      if ! good and wordcount(extracted).length == list.length
        dp "found it: #{pattern}"
        good = extracted
      end
    }
    good || [*1..list.length]
  end
  
  def getext(list)
    list[0].match(/(\.[^.]+)$/)[0]
  end

  def process(list)

    nums = getnums(list).map { |num| num.sub(/^0/, '') }
    dp "nums is #{nums}"
    
    numsize = nums.map {|num| num.length}.max

    base = getbase list, 8-numsize
    dp "numsize is #{numsize}, base is #{base}"

    ext = getext list
    dp "ext is #{ext}"

    nums.map {|num| "#{base}#{num}#{ext}" }
  end
end

if $0 == __FILE__
  # direct call

  lines = File.open(ARGV[0]).readlines.map {|x| x.chomp}

  e = Eightify.new
  newlines = e.process lines
  puts newlines.join("\n")

end
