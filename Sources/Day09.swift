import Algorithms
import DequeModule

struct Day09: AdventDay {
  var data: String

  func part1() -> Any {
    let tileCoordinates = data
      .split(separator: "\n")
      .map { (x: Int($0.split(separator: ",")[0])!, y: Int($0.split(separator: ",")[1])!) }
    
    var maxArea = 0
    
    for possibleCombo in tileCoordinates.combinations(ofCount: 2) {
      let cornerA = possibleCombo[0]
      let cornerB = possibleCombo[1]
      
      // +1 to make it inclusive of the outer bound
      let area = (abs(cornerA.x.distance(to: cornerB.x)) + 1) * (abs(cornerA.y.distance(to: cornerB.y)) + 1)
      
      if area > maxArea {
        maxArea = area
      }
    }
    
    return maxArea
  }

  func part2() -> Any {
    enum FloorTileType: Character {
      case empty = "."
      case red = "#"
      case green = "X"
    }
    
    func outlineBoard(redCorners: [(x: Int, y: Int)]) -> [[FloorTileType?]] {
      // Index with board[x][y]
      // nil will represent truly unknown
      var board: [[FloorTileType?]] = [[nil]]
      
      var maxY: Int {
        get {
          assert(board.allSatisfy({ $0.count == board[0].count }), "maxY is not properly propogated")
          return board[0].count - 1
        }
        set(newMaxY) {
          for columnIndex in board.indices {
            board[columnIndex].append(contentsOf: Array(repeating: nil, count: newMaxY - board[columnIndex].count + 1))
          }
          assert(maxY == newMaxY)
        }
      }
      var maxX: Int {
        get {
          return board.count - 1
        }
        set(newMaxX) {
          board += Array(repeating: Array(repeating: nil, count: maxY + 1), count: newMaxX - board.count + 1)
          assert(maxX == newMaxX)
        }
      }
      
      func drawGreenLineBetween(_ startCorner: (x: Int, y: Int), and endCorner: (x: Int, y: Int)) {
        if startCorner.x == endCorner.x {
          for y in (min(startCorner.y, endCorner.y) + 1)..<max(startCorner.y, endCorner.y) {
            board[startCorner.x][y] = .green
          }
        } else {
          assert(startCorner.y == endCorner.y)
          for x in (min(startCorner.x, endCorner.x) + 1)..<max(startCorner.x, endCorner.x) {
            board[x][startCorner.y] = .green
          }
        }
      }
      
      for (index, (x, y)) in redCorners.enumerated() {
        if x > maxX {
          maxX = x
        }
        if y > maxY {
          maxY = y
        }
        
        board[x][y] = .red
        
        guard index > 0 else { continue }
        
        let prevRedCorner = redCorners[index - 1]
        drawGreenLineBetween(prevRedCorner, and: (x, y))
      }
      drawGreenLineBetween(redCorners.first!, and: redCorners.last!)
      
      
      return board
    }
    
    func printBoard(_ board: [[FloorTileType?]]) {
      for y in 0..<board[0].count {
        for x in 0..<board.count {
          print(board[x][y]?.rawValue ?? ".", terminator: "")
        }
        print()
      }
    }
    
    var edges = [(start: (x: Int, y: Int), end: (x: Int, y: Int))]()
    
    var corner0: (x: Int, y: Int)?
    
    for (offset, line) in data.split(separator: "\n").enumerated() {
      let x = Int(line.split(separator: ",")[0])!
      let y = Int(line.split(separator: ",")[1])!
      guard offset > 0 else { corner0 = (x, y); continue }
      
      if offset == 1 {
        edges.append((start: corner0!, end: (x, y)))
      } else {
        edges.append((start: edges.last!.end, end: (x,y)))
      }
    }
    edges.append((start: edges.last!.end, end: corner0!))
    
    let redCorners = edges.map({$0.start})
    
    let xValues = redCorners.map({$0.x}).sorted()
    let yValues = redCorners.map({$0.y}).sorted()
    
    var compressedXLookupTable = [Int:Int]()
    var currIndex = 0
    for xValue in xValues where compressedXLookupTable[xValue] == nil {
      compressedXLookupTable[xValue] = currIndex
      currIndex += 2 // Do this to give some breathing room between walls
    }
    
    var compressedYLookupTable = [Int:Int]()
    currIndex = 0
    for yValue in yValues where compressedYLookupTable[yValue] == nil {
      compressedYLookupTable[yValue] = currIndex
      currIndex += 2 // Do this to give some breathing room between walls
    }
    
    let board = outlineBoard(redCorners: redCorners.map { (compressedXLookupTable[$0.x]!, compressedYLookupTable[$0.y]!) })
    
    func minAndMax(_ a: Int, _ b: Int) -> (min: Int, max: Int) {
      return (min(a, b), max(a, b))
    }
    
    // Inspired by https://www.reddit.com/r/adventofcode/comments/1pi3hff/2025_day_9_part_2_a_simple_method_spoiler
    func intersectsAnyEdges(start: (x: Int, y: Int), end: (x: Int, y: Int)) -> Bool {
      let (minX, maxX) = minAndMax(start.x, end.x)
      let (minY, maxY) = minAndMax(start.y, end.y)
      
      for edge in edges {
        let (edgeMinX, edgeMaxX) = minAndMax(edge.start.x, edge.end.x)
        let (edgeMinY, edgeMaxY) = minAndMax(edge.start.y, edge.end.y)
        if minX < edgeMaxX && maxX > edgeMinX && minY < edgeMaxY && maxY > edgeMinY {
          return true
        }
      }
      return false
    }
    
    func areaOf(rectangle: [(x: Int, y: Int)]) -> Int {
      let start = rectangle[0]
      let end = rectangle[1]
      return (abs(start.x - end.x) + 1) * (abs(start.y - end.y) + 1)
    }
    
    func canFindExitPath(start: (x: Int, y: Int)) -> Bool {
      let boardMaxX = board.count - 1
      let boardMaxY = board[0].count - 1
      
      struct BoardPosition: Hashable, Equatable {
        let x: Int
        let y: Int
      }
      
      var visited: Set<BoardPosition> = []
      var queue: Deque<BoardPosition> = [.init(x: start.x, y: start.y)]
      
      while !queue.isEmpty {
        let pos = queue.popLast()!
        
        guard visited.insert(pos).inserted else { /*Already in there*/ continue }
        
        if board[pos.x][pos.y] == .red || board[pos.x][pos.y] == .green {
          continue
        }
        
        if pos.x <= 0 || pos.y <= 0 || pos.x >= boardMaxX || pos.y >= boardMaxY  {
          return true // Found a way to the edge
        }
        
        queue.prepend(.init(x: pos.x - 1, y: pos.y))
        queue.prepend(.init(x: pos.x + 1, y: pos.y))
        queue.prepend(.init(x: pos.x, y: pos.y - 1))
        queue.prepend(.init(x: pos.x, y: pos.y + 1))
      }
      
      return false
    }
    
    // Sort by largest area first, so we can return the first that works
    rectangles: for rectangle in redCorners.combinations(ofCount: 2).sorted(by: { areaOf(rectangle: $0) > areaOf(rectangle: $1) }) {
      guard !intersectsAnyEdges(start: rectangle[0], end: rectangle[1]) else { continue }
      
      let (minX, _) = minAndMax(compressedXLookupTable[rectangle[0].x]!, compressedXLookupTable[rectangle[1].x]!)
      let (minY, _) = minAndMax(compressedYLookupTable[rectangle[0].y]!, compressedYLookupTable[rectangle[1].y]!)
      
      // DFS is not actually necessary for the real challenge due to the input shape, but it makes the algorithm always correct
      guard !canFindExitPath(start: (minX + 1, minY + 1)) else { continue rectangles }
      
      return areaOf(rectangle: rectangle)
    }
    
    fatalError("Should have found something")
  }
}
