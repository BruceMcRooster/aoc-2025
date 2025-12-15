import Algorithms

struct Day11: AdventDay {
  var data: String

  func part1() -> Any {
    var graph = [String: [String]]()
    
    for line in data.split(separator: "\n") {
      let colonSplit = line.split(separator: ": ")
      let outputs = colonSplit[1].split(separator: " ").map(String.init)
      graph[String(colonSplit.first!)] = outputs
    }
    
    var reachedCount = 0
    
    var currPlaces = ["you"]
    
    while !currPlaces.isEmpty {
      let nextToContinue = currPlaces.popLast()!
      
      guard nextToContinue != "out" else { reachedCount += 1; continue }
      
      currPlaces.append(contentsOf: graph[nextToContinue]!)
    }
    
    return reachedCount
  }

  func part2() -> Any {
    return 0
  }
}
