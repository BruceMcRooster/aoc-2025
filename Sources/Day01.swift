import Algorithms

struct Day01: AdventDay {
  var data: String

  func part1() -> Any {
    var currPos = 50
    
    var zeroCount = 0
    
    for line in data.split(separator: "\n") {
      let goLeft = line.starts(with: "L")
      
      let amount = Int(String(line.dropFirst()))!
      
      currPos += goLeft ? -amount : amount
      
      while currPos < 0 { currPos += 100 }
      while currPos > 99 { currPos -= 100 }
      
      if currPos == 0 { zeroCount += 1 }
    }
    
    return zeroCount
  }

  func part2() -> Any {
    return 0
  }
}
