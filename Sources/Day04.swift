import Algorithms
import Collections

struct Day04: AdventDay {
  var data: String

  func part1() -> Any {
    let mapArray = data.split(separator: "\n").map(Array.init)
    
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
    var mapArray = data.split(separator: "\n").map(Array.init)
    
    var forkliftableRolls = 0
    
    func getNeighbors(row: Int, col: Int) -> [(row: Int, col: Int)] {
      var result = [(row: Int, col: Int)]()
      
      if 0 < row, 0 < col { result.append((row-1, col-1)) }
      if 0 < col { result.append((row, col-1)) }
      if 0 < col, row < mapArray.count - 1 { result.append((row+1, col-1)) }
      if row < mapArray.count - 1 { result.append((row + 1, col)) }
      if row < mapArray.count - 1, col < mapArray[row].count - 1 { result.append((row+1, col + 1)) }
      if col < mapArray[row].count - 1 { result.append((row, col+1)) }
      if 0 < row, col < mapArray[row].count - 1 { result.append((row - 1, col + 1)) }
      if 0 < row { result.append((row-1, col)) }
      
      return result
    }
    
    func isForkliftable(row: Int, col: Int) -> Bool {
      var totalNeighborRollsCount = 0
      
      for neighbor in getNeighbors(row: row, col: col) where mapArray[neighbor.row][neighbor.col] == "@" {
        totalNeighborRollsCount += 1
      }
      
      return totalNeighborRollsCount < 4
    }
    
    var rollsToCheck = Deque<(row: Int, col: Int)>()
    
    for row in 0..<mapArray.count {
      for col in 0..<mapArray[row].count {
        if mapArray[row][col] == "@" {
          rollsToCheck.append((row, col))
        }
      }
    }
        
    while !rollsToCheck.isEmpty {
      let check = rollsToCheck.popFirst()!
      
      guard mapArray[check.row][check.col] == "@" else { continue }
      
      if isForkliftable(row: check.row, col: check.col) {
        forkliftableRolls += 1
        mapArray[check.row][check.col] = "x"
        rollsToCheck.append(contentsOf: getNeighbors(row: check.row, col: check.col))
      }
    }
    
    return forkliftableRolls
  }
}
