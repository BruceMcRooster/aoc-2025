import Algorithms
import OrderedCollections

struct Day07: AdventDay {
  var data: String

  func part1() -> Any {
    let table = data.split(separator: "\n", omittingEmptySubsequences: true).map(Array.init)
    let sourcePosition = table[0].firstIndex(of: "S")!
    
    let width = table[0].count
    let maxY = table.count - 1
    
    
    struct Position: Hashable, Equatable {
      let x: Int
      let y: Int
    }
    
    var splitterPositions = Set<Position>()
    
    for (y, line) in data.split(separator: "\n").enumerated() {
      let startIndex = line.startIndex
      
      for index in line.indices {
        if line[index] == "^" {
          splitterPositions.insert(Position(x: line.distance(from: startIndex, to: index), y: y))
        }
      }
    }
    
    // Start just below the source
    var beamPositions: OrderedSet<Position> = [Position(x: sourcePosition, y: 1)]
    
    var splitCount = 0
    
    func advanceBeam(at position: Position) {
      guard position.y + 1 <= maxY else { return }
      guard table[position.y + 1][position.x] == "^" else {
        beamPositions.append(Position(x: position.x, y: position.y + 1))
        return
      }
      
      splitCount += 1
      assert(position.x - 1 >= 0 && position.x + 1 < width, "There are splitters on the edge of the board; my assumption was wrong that there were not")
      
      beamPositions.append(Position(x: position.x-1, y: position.y+1))
      beamPositions.append(Position(x: position.x+1, y: position.y+1))
    }
    
    func printBoard() {
      for y in 0...maxY {
        for x in 0..<width {
          if beamPositions.contains(Position(x: x, y: y)) {
            print("|", terminator: " ")
          } else {
            print(table[y][x], terminator: " ")
          }
        }
        print("\n")
      }
    }
    
    while !beamPositions.isEmpty {
      let beamPosition = beamPositions.removeFirst()
      advanceBeam(at: beamPosition)
//      print("Advanced \(beamPosition), \(splitCount) splits and")
//      printBoard()
    }
    
    return splitCount
  }

  func part2() -> Any {
    let table = data.split(separator: "\n", omittingEmptySubsequences: true).map(Array.init)
    let sourcePosition = table[0].firstIndex(of: "S")!
    
    let maxY = table.count - 1
    
    
    struct Position: Hashable, Equatable {
      let x: Int
      let y: Int
    }
    
    var pathsToReach: [Position : Int] = [Position(x: sourcePosition, y: 1): 1]
    
    var beamPositionsToConsider: OrderedSet<Position> = [Position(x: sourcePosition, y: 1)]
    
    while !beamPositionsToConsider.isEmpty {
      let beamPosition = beamPositionsToConsider.removeFirst()
      
      guard beamPosition.y < maxY else { continue }
      guard table[beamPosition.y + 1][beamPosition.x] == "^" else {
        let new = Position(x: beamPosition.x, y: beamPosition.y + 1)
        pathsToReach[new, default: 0] += pathsToReach[beamPosition]!
        beamPositionsToConsider.append(new)
        continue
      }
      let left = Position(x: beamPosition.x-1, y: beamPosition.y+1)
      beamPositionsToConsider.append(left)
      pathsToReach[left, default: 0] += pathsToReach[beamPosition]!
      
      let right = Position(x: beamPosition.x+1, y: beamPosition.y+1)
      beamPositionsToConsider.append(right)
      pathsToReach[right, default: 0] += pathsToReach[beamPosition]!
      
    }
    
    return pathsToReach.filter({$0.key.y == maxY}).reduce(0, {$0 + $1.value})
  }
}
