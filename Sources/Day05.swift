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
    let sections = data.split(separator: "\n\n", maxSplits: 1)
    
    let ranges: [ClosedRange<Int>] = sections[0]
      .matches(of: /(?<lower>\d+)-(?<upper>\d+)/)
      .map {
        Int($0.output.lower)!...Int($0.output.upper)!
      }
    
    let rangeData: [Int] = ranges
      .reduce(into: []) { partialResult, range in
        partialResult.append(range.lowerBound)
        // Negative numbers will indicate the end of a range
        partialResult.append(-range.upperBound)
      }
      .sorted { left, right in
        // ordering positives (range starts) before negatives (range ends) solves an issue with
        // single-integer ranges that start (and end) on the end of another range
        if abs(left) != abs(right) { abs(left) < abs(right) } else { left > right }
      }
    
    var currRangeDepth = 0
    
    var currRangeStart: Int?
    
    var bigRanges = [ClosedRange<Int>]()
    
    for rangeMarker in rangeData {
      if rangeMarker >= 0 {
        currRangeDepth += 1
        if currRangeStart == nil {
          assert(currRangeDepth == 1)
          currRangeStart = rangeMarker
        }
      } else {
        currRangeDepth -= 1
        if currRangeDepth == 0 {
          let start = currRangeStart!
          let end = -rangeMarker
          bigRanges.append(start...end)
          currRangeStart = nil
        }
      }
    }
    
    func sanityCheckBigRanges(smallRanges: [ClosedRange<Int>], bigRanges: [ClosedRange<Int>]) -> Bool {
      var foundEnds = Array(repeating: (low: false, high: false), count: bigRanges.count)
      
      smallRangesLoop: for smallRange in smallRanges {
        for (bigRangeIndex, bigRange) in bigRanges.enumerated() {
          if bigRange.lowerBound <= smallRange.lowerBound && smallRange.upperBound <= bigRange.upperBound {
            if bigRange.lowerBound == smallRange.lowerBound {
              foundEnds[bigRangeIndex].low = true
            }
            if bigRange.upperBound == smallRange.upperBound {
              foundEnds[bigRangeIndex].high = true
            }
            
//            print("small range \(smallRange) was in big range \(bigRange)")
            
            continue smallRangesLoop
          }
        }
        print("Small range \(smallRange) was not contained in any big range")
        return false
      }
      
      for (index, foundEnd) in foundEnds.enumerated() {
        if !foundEnd.low || !foundEnd.high {
          print("Failed to find ends for index \(index) (\(bigRanges[index]))")
          return false
        }
      }
      
      return true
    }
    
    assert(sanityCheckBigRanges(smallRanges: ranges, bigRanges: bigRanges))
    
    return bigRanges.reduce(0) { count, range in
      count + range.count
    }
  }
}
