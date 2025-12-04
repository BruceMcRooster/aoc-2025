import Algorithms

struct Day03: AdventDay {
  var data: String

  func part1() -> Any {
    let banks = data.split(separator: "\n").map({$0.utf8.map({$0 - 48})})
    
    var totalJoltage = 0
    
    for bank in banks {
      var largestFirst = bank.first!
      var largestFirstIndex = 0
      
      for cellIndex in 1..<bank.count - 1 {
        guard largestFirst < 9 else { break } // It's definitely the biggest, mostly just a speedup
        if bank[cellIndex] > largestFirst {
          largestFirst = bank[cellIndex]
          largestFirstIndex = cellIndex
        }
      }
      
      var largestSecond = bank[largestFirstIndex + 1]
      for cellIndex in largestFirstIndex+1..<bank.count {
        guard largestSecond < 9 else { break }
        if bank[cellIndex] > largestSecond {
          largestSecond = bank[cellIndex]
        }
      }
      
      totalJoltage += Int(largestFirst * 10 + largestSecond)
    }
    
    return totalJoltage
  }

  func part2() -> Any {
    let banks = data.split(separator: "\n").map({$0.utf8.map({$0 - 48})})
    
    var totalJoltage = 0
    
    for bank in banks {
      var currIndex = 0
      
      for lookingForCellNumber in stride(from: 11, through: 0, by: -1) {
        let searchSpace = bank[currIndex..<bank.count-lookingForCellNumber]
        
        let max = searchSpace.max()!
        let maxIndex = searchSpace.firstIndex(of: max)!
        
        let multiplier = {
          var val = 1
          for _ in 0..<lookingForCellNumber {
            val *= 10
          }
          return val
        }()
        
        totalJoltage += Int(max) * multiplier
        currIndex = maxIndex + 1
      }
    }
    
    return totalJoltage
  }
}
