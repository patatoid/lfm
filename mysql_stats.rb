#!/usr/bin/ruby

File.open('mysql_stats.txt') do |input|
  File.open('mysql_stats.csv', 'w') do |output|
    i=0
    while l = input.gets
      if i%2 == 0 
        output.print l.chop! + ";"
      else
        output.print l
      end
      i+=1
    end
  end
end
