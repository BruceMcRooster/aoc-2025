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
    
    return search(from: "you", for: "out", in: graph)
  }

  // Thanks for inspiration from https://www.reddit.com/r/adventofcode/comments/1pjp1rm/comment/ntm4x2k/ to go backwards instead of forwards
  // There are way too many paths to try a forward search
  private func search(
    from start: String,
    for target: String,
    in graph: [String: [String]]
  ) -> Int {
    var waysToGetThereCache = [start : 1]
    
    func numberOfWaysToGet(to innerTarget: String) -> Int {
      if let knownWayToGetThere = waysToGetThereCache[innerTarget] {
        return knownWayToGetThere
      }
      
      var result = 0
      
      for prev in graph.keys where graph[prev]!.contains(innerTarget) {
//        print("at \(innerTarget), checking previous \(prev)")
        result += numberOfWaysToGet(to: prev)
      }
      
      waysToGetThereCache[innerTarget] = result
      
      return result
    }
    
    return numberOfWaysToGet(to: target)
  }
  
  func generateMermaidChart(of graph: [String : [String]]) {
    print("flowchart TD")
    for (key, value) in graph {
      for val in value {
        print("\t\(key) --&gt; \(val)")
      }
    }
  }
  
  func part2() -> Any {
    var graph = [String: [String]]()
    
    for line in data.split(separator: "\n") {
      let colonSplit = line.split(separator: ": ")
      let outputs = colonSplit[1].split(separator: " ").map(String.init)
      graph[String(colonSplit.first!)] = outputs
    }
//    
//    generateMermaidChart(of: graph)
//    return 0
        
    let waysFromDACToFFT = search(from: "dac", for: "fft", in: graph)
//    print("Found \(waysFromDACToFFT) ways to get from dac to fft")
    let waysFromFFTToDAC = search(from: "fft", for: "dac", in: graph)
//    print("Found \(waysFromFFTToDAC) ways to get from fft to dac")
    
    
    if waysFromFFTToDAC == 0 {
      let waysFromSVRToDAC = search(from: "svr", for: "dac", in: graph)
      let waysFromFFTToOUT = search(from: "fft", for: "out", in: graph)
      
      return waysFromSVRToDAC * waysFromDACToFFT * waysFromFFTToOUT
    } else {
      assert(waysFromDACToFFT == 0)
      
      let waysFromSVRToFFT = search(from: "svr", for: "fft", in: graph)
      let waysFromDACToOUT = search(from: "dac", for: "out", in: graph)
      
      return waysFromSVRToFFT * waysFromFFTToDAC * waysFromDACToOUT
    }
  }
}
