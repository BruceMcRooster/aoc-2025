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
    let table = Array(data.replacingOccurrences(of: "\n", with: ""))
    let tableWidth = data.distance(from: data.startIndex, to: data.firstIndex(of: "\n")!)
    // This makes a critical assumption about the file being newline terminated.
    // I'm not positive this is necessarily the case,
    // but downloading the puzzle input directly does include a terminating newline
    let tableHeight = data.count(where: { $0 == "\n" })
    assert(table.count == tableWidth * tableHeight)
    
    var sumTotal = 0
    
    var bufferedNumbers = [Int]()
    
    for col in stride(from: tableWidth-1, through: 0, by: -1) {
      var curNum: Int?
      
      enum Operator {
        case add, multiply
      }
      
      var foundOperator: Operator?
      
      for row in stride(from: col, to: table.count, by: tableWidth) {
        let char = table[row]
        
        if let digit = Int("\(char)") {
          if let curNumVal = curNum {
            curNum = curNumVal * 10 + digit
          } else {
            curNum = digit
          }
        } else {
          if char == "+" {
            foundOperator = .add
            break
          } else if char == "*" {
            foundOperator = .multiply
            break
          }
        }
      }
      
      if let curNum {
        bufferedNumbers.append(curNum)
      }
      
      if let foundOperator {
        assert(!bufferedNumbers.isEmpty, "Running operator on empty buffered numbers")
        switch foundOperator {
          case .add:
          sumTotal += bufferedNumbers.reduce(0, +)
        case .multiply:
          sumTotal += bufferedNumbers.reduce(1, *)
        }
        bufferedNumbers.removeAll(keepingCapacity: true)
      }
    }
    return sumTotal
  }
}
