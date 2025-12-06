import Algorithms

struct Day06: AdventDay {
  var data: String

  func part1() -> Any {
    let lines = data.split(separator: "\n")
    
    var totals: [Int] = lines.last!.split(separator: /\s+/).map { op in
      switch op {
      case "+": return 0
      case "*": return -1 // We'll use negatives as the flag for whether to multiply or add
      default: fatalError("unexpected operator: \(op)")
      }
    }
    
    for line in lines.dropLast() {
      for (index, num) in line.split(separator: /\s+/).enumerated() {
        let intNum = Int(num)!
        
        if totals[index] >= 0 {
          totals[index] += intNum
        } else {
          totals[index] *= intNum
        }
      }
    }
    
    return totals.reduce(0, { $0 + abs($1) })
  }

  func part2() -> Any {
    return 0
  }
}
