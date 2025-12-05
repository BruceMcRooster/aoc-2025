import Algorithms

struct Day05: AdventDay {
  var data: String

  func part1() -> Any {
    let sections = data.split(separator: "\n\n", maxSplits: 1)
    
    let ranges: [ClosedRange<Int>] = sections[0]
      .matches(of: /(?<lower>\d+)-(?<upper>\d+)/)
      .map {
        Int($0.output.lower)!...Int($0.output.upper)!
      }
    
    var freshProduceCount = 0
    
    for id in sections[1].split(separator: "\n").map({ Int(String($0))! }) {
      for range in ranges {
        if range.contains(id) {
          freshProduceCount += 1
          break
        }
      }
    }
    
    return freshProduceCount
  }

  func part2() -> Any {
    return 0
  }
}
