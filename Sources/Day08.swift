import Algorithms

infix operator <->: RangeFormationPrecedence

struct Day08: AdventDay {
  init(data: String) {
    self.data = data
  }
  
  var data: String
  
  var numberOfConnectionsToMake = 1_000

  struct JunctionBox: Hashable, Equatable, Comparable {
    var x: Double
    var y: Double
    var z: Double
    
    init(x: Int, y: Int, z: Int) {
      if let xInt = Double(exactly: x), let yInt = Double(exactly: y), let zInt = Double(exactly: z) {
        self.x = xInt
        self.y = yInt
        self.z = zInt
      } else {
        fatalError("Cannot precisely represent junction box at \(x), \(y), \(z)")
      }
    }
    
    static func <(lhs: JunctionBox, rhs: JunctionBox) -> Bool {
      if lhs.x != rhs.x {
        return lhs.x < rhs.x
      }
      if lhs.y != rhs.y {
        return lhs.y < rhs.y
      }
      if lhs.z != rhs.z {
        return lhs.z < rhs.z
      }
      assertionFailure("Two equal elements were compared")
      return true
    }
    
    /// Returns distance between two junction boxes
    static func <->(lhs: JunctionBox, rhs: JunctionBox) -> Double {
      return Double.sqrt(Double.pow(lhs.x - rhs.x, 2) + Double.pow(lhs.y - rhs.y, 2) + Double.pow(lhs.z - rhs.z, 2))
    }
  }
  
  struct UnionFindDataStructure {
    enum BoxGraphDatum: Equatable {
      case otherBox(JunctionBox)
      case treeSize(Int)
    }
    
    var boxGraph = [JunctionBox : BoxGraphDatum]()
    
    mutating func connect(_ a: JunctionBox, to b: JunctionBox) {
      let aCanonical = getCanonicalRepresentation(of: a)
      let bCanonical = getCanonicalRepresentation(of: b)
      
      // Already connected somehow
      guard aCanonical != bCanonical else { return }
      
      guard case let BoxGraphDatum.treeSize(aSize) = boxGraph[aCanonical, default: .treeSize(1)] else {
        fatalError()
      }
      guard case let BoxGraphDatum.treeSize(bSize) = boxGraph[bCanonical, default: .treeSize(1)] else {
        fatalError()
      }
      
//      print("Connecting \(a) to \(b) by connecting \(aCanonical) (size \(aSize)) to \(bCanonical) (size \(bSize))")
      
      if aSize > bSize {
        boxGraph[bCanonical] = .otherBox(aCanonical)
        boxGraph[aCanonical] = .treeSize(aSize + bSize)
      } else {
        boxGraph[aCanonical] = .otherBox(bCanonical)
        boxGraph[bCanonical] = .treeSize(aSize + bSize)
      }
      
      assert(getCanonicalRepresentation(of: a) == getCanonicalRepresentation(of: b), "Connection did not work")
    }
    
    mutating func getCanonicalRepresentation(of box: JunctionBox) -> JunctionBox {
      var searchPath = [box]
      
      while case let BoxGraphDatum.otherBox(other) = boxGraph[searchPath.last!, default: .treeSize(1)] {
        searchPath.append(other)
      }
      
      // Path compression
      for compressions in searchPath.dropLast() {
        boxGraph[compressions] = .otherBox(searchPath.last!)
      }
      
      return searchPath.last!
    }
    
    func getLargestConnectedGraphSize() -> Int {
      var max = 0
      
      for boxDatum in boxGraph.values {
        guard case let BoxGraphDatum.treeSize(size) = boxDatum else { continue }
        if size > max { max = size }
      }
      
      return max
    }
  }
  
  func part1() -> Any {
    let allBoxes = data.split(separator: "\n").map({ $0.wholeMatch(of: /(?<x>\d+),(?<y>\d+),(?<z>\d+)/)!.output }).map({ JunctionBox(x: Int($0.x)!, y: Int($0.y)!, z: Int($0.z)!) })
    
    var boxGraph = UnionFindDataStructure()
    
    for possibleConnection in allBoxes
      .combinations(ofCount: 2)
      .sorted(by: { $0[0]<->$0[1] < $1[0]<->$1[1] })
      .prefix(numberOfConnectionsToMake) // Limit to the number of connections we want to make
    {
      boxGraph.connect(possibleConnection[0], to: possibleConnection[1])
    }
    
    return boxGraph.boxGraph.values.map({ boxGraphDatum in
      if case let UnionFindDataStructure.BoxGraphDatum.treeSize(size) = boxGraphDatum {
        return size
      } else {
        return 1
      }
    }).sorted(by: >).prefix(3)
      .reduce(1, *)
  }

  func part2() -> Any {
    let allBoxes = data.split(separator: "\n").map({ $0.wholeMatch(of: /(?<x>\d+),(?<y>\d+),(?<z>\d+)/)!.output }).map({ JunctionBox(x: Int($0.x)!, y: Int($0.y)!, z: Int($0.z)!) })
    
    var boxGraph = UnionFindDataStructure()
    
    for possibleConnection in allBoxes
      .combinations(ofCount: 2)
      .sorted(by: { $0[0]<->$0[1] < $1[0]<->$1[1] }) {
      boxGraph.connect(possibleConnection[0], to: possibleConnection[1])
      if boxGraph.getLargestConnectedGraphSize() == allBoxes.count {
        // This was the connection that made that happen
        return Int(exactly: possibleConnection[0].x * possibleConnection[1].x)!
      }
    }
    fatalError("No final connection found!")
  }
}
