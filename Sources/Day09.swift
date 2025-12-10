import Algorithms

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
    return 0
  }
}
