import Algorithms

struct Day02: AdventDay {
  var data: String

  func part1() -> Any {
    let matches = data.matches(of: /(?<start>\d+)-(?<end>\d+),?/)
    
    var sum = 0
    
    for match in matches {
      for id in Int(String(match.output.start))!...Int(String(match.output.end))! {
        let asString = String(id)
        let length = asString.count
        guard length & 1 == 0 else { continue }
        
        let firstHalf = asString.prefix(length / 2)
        let secondHalf = asString.suffix(length / 2)
        
        if firstHalf == secondHalf { sum += id }
      }
    }
    
    return sum
  }

  func part2() -> Any {
    let matches = data.matches(of: /(?<start>\d+)-(?<end>\d+),?/)
    
    var sum = 0
    
    for match in matches {
      for id in Int(String(match.output.start))!...Int(String(match.output.end))! {
        let asString = String(id)
        
        let regex = /^(.+?)\1+$/
        
        if let _ = asString.wholeMatch(of: regex) {
          sum += id
        }
      }
    }
    
    return sum
  }
}
