def pascal(n)
  if n <= 0
    puts "Brak trojkata"
    return
  end
  print("1\n")
  if n == 1
    return
  end
  #n >=2
  line = [1,1]
  for i in 0..n-2 do
    next_line = [1]
    print ("1 ")
    for j in 1..i do
      next_line << line[j-1] + line[j]
      print next_line[j].to_s + " "
    end
    print ("1\n")
    line = next_line << 1
  end
end


pascal(6)
