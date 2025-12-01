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
    // The brain juices were not flowing this morning...
    struct Dial {
      var currPos = 50
      var zeroCount = 0
      
      mutating func normalize() {
        if currPos < 0 { currPos += 100 }
        if currPos > 99 { currPos -= 100 }
        assert(0 <= currPos && currPos <= 99, "Normalize called after too big of a step")
      }
      
      mutating func spinLeft(_ amount: Int) {
        for _ in 0..<amount {
          currPos -= 1
          normalize()
          if currPos == 0 { zeroCount += 1 }
        }
      }
      
      mutating func spinRight(_ amount: Int) {
        for _ in 0..<amount {
          currPos += 1
          normalize()
          if currPos == 0 { zeroCount += 1 }
        }
      }
    }
    
    var dial = Dial()
    
    for line in data.split(separator: "\n") {
      let goLeft = line.starts(with: "L")
      
      let amount = Int(String(line.dropFirst()))!
      
      if goLeft { dial.spinLeft(amount) }
      else { dial.spinRight(amount) }
    }
    
    return dial.zeroCount
  }
}
