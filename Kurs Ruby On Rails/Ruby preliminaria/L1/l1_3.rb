def wielkaliczba(n)
  digits_hash = {
    "0"=>[" xxx ","     ","x   x","     ","x   x","     ","x   x","     "," xxx "],
    "1"=>["    x","     ","  x x", "     ","x   x", "     ","    x","     ","    x" ],
    "2"=>["  x  ","     ", "x   x","     ","   x ","     "," x   ","     ","xxxxx"],
    "3"=>[" xxxx ","      ", "x   xx","      ","   xx ","      ","x   xx","      "," xxxx "],
    "4"=>["    x","     ","  x  ","     ","x x x","     ","    x","     ","    x"],
    "5"=>["xxxxx","     ","x    ","     ","xxxx ","     ","    x","    ","xxxx "],
    "6"=>[" xxx ","     ", "x    ","     ","xxxx ","     ","x   x","     "," xxx "],
    "7"=>["xxxxx","     ","   x ","     "," xxx ","     "," x   ","     ","x    "],
    "8"=>[" xxx ","     ","x   x","     "," xxx ","     ","x   x","     "," xxx "],
    "9"=>[" xxx ","     ","x   x","     "," xxxx","     ","    x","     "," xxx "]
  }
  n = n.to_s.split("")
  for i in 0..8 do
    n.each do |e|
      print digits_hash[e][i] + "   "
    end
    print"\n"
  end
end

wielkaliczba(2454)
