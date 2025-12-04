import Algorithms

struct Day04: AdventDay {
  var data: String
  
  var mapArray: [[Character]]
  
  init(data: String) {
    self.data = data
    self.mapArray = data.split(separator: "\n").map(Array.init)
  }

  func part1() -> Any {
    var forkliftableRolls = 0
    
    for row in mapArray.indices {
      for col in mapArray[row].indices {
        guard mapArray[row][col] == "@" else { continue }
        
        var totalNeighborRollsCount = 0
        
        if 0 < row, 0 < col, mapArray[row - 1][col - 1] == "@" { totalNeighborRollsCount += 1 }
        if 0 < col, mapArray[row][col - 1] == "@" { totalNeighborRollsCount += 1 }
        if 0 < col, row < mapArray.count - 1, mapArray[row + 1][col - 1] == "@" { totalNeighborRollsCount += 1 }
        if row < mapArray.count - 1, mapArray[row + 1][col] == "@" { totalNeighborRollsCount += 1 }
        if row < mapArray.count - 1, col < mapArray[row].count - 1, mapArray[row + 1][col + 1] == "@" { totalNeighborRollsCount += 1 }
        if col < mapArray[row].count - 1, mapArray[row][col + 1] == "@" { totalNeighborRollsCount += 1 }
        if 0 < row, col < mapArray[row].count - 1, mapArray[row - 1][col + 1] == "@" { totalNeighborRollsCount += 1 }
        if 0 < row, mapArray[row - 1][col] == "@" { totalNeighborRollsCount += 1 }
        
        if totalNeighborRollsCount < 4 {
          forkliftableRolls += 1
        }
      }
    }
    
    return forkliftableRolls
  }

  func part2() -> Any {
    return 0
  }
}
