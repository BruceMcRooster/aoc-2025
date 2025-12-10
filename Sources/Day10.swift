import Algorithms
import DequeModule
import BitCollections

fileprivate extension BitArray {
  static func ^(lhs: BitArray, rhs: BitArray) -> BitArray {
    precondition(lhs.count == rhs.count)
    var result = BitArray()
    for i in lhs.indices {
      result.append(lhs[i] != rhs[i])
    }
    return result
  }
}

fileprivate extension Array<Int> {
  func incrementedWhereTrue(in button: BitArray) -> Self {
    precondition(button.count == self.count)
    
    var result = [Int]()
    
    for i in self.indices {
      result.append(self[i] + (button[i] ? 1 : 0))
    }
    return result
  }
  
  static func <=(lhs: Self, rhs: Self) -> Bool {
    precondition(lhs.count == rhs.count)
    
    for i in lhs.indices {
      if lhs[i] > rhs[i] { return false }
    }
    return true
  }
}

struct Day10: AdventDay {
  var data: String

  struct Machine {
    let target: BitArray
    let buttons: Set<BitArray>
    let joltageTargets: [Int]
    
    init(fromLine line: some StringProtocol) {
      var targetBitArray: BitArray = []
      var allButtons: Set<BitArray> = []
      
      var currButtonBitArray: BitArray?
              
      var joltageTargetArray = [Int]()
      
      var currNum = 0
      
      for char in line {
        switch char {
        case "[", "]": continue
        case ".": targetBitArray.append(false)
        case "#": targetBitArray.append(true)
        case "(": currButtonBitArray = BitArray(repeating: false, count: targetBitArray.count)
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9": currNum *= 10; currNum += Int(String(char))!
        case ",": if currButtonBitArray != nil { // Allows us to ignore when done with buttons and onto joltage
          currButtonBitArray![currNum] = true
        } else {
          joltageTargetArray.append(currNum)
        }
          currNum = 0 // Definitely have to reset even when ignoring the joltage, since otherwise we integer overflow
        case ")": if currButtonBitArray != nil { // Allows us to ignore when done with buttons and onto joltage
                    currButtonBitArray![currNum] = true
                    currNum = 0
                  }
                  allButtons.insert(currButtonBitArray!); currButtonBitArray = nil
        case "}":
          joltageTargetArray.append(currNum)
          break
        default: continue
        }
      }
      
      self.target = targetBitArray
      self.buttons = allButtons
      self.joltageTargets = joltageTargetArray
    }
  }
  
  func part1() -> Any {
    let allMachines = data.split(separator: "\n").map(Machine.init(fromLine:))
    
    var sumOfPresses = 0
    
    for machine in allMachines {
      // Stores the state, and the depth to get there
      var statesToCheck: Deque<(from: BitArray, to: BitArray)> = []
      
      for button in machine.buttons {
        statesToCheck.append((from: BitArray(repeating: false, count: machine.target.count), to: button))
      }
      
      var foundStates: [BitArray: Int] = [.init(repeating: false, count: machine.target.count) : 0]
      
      while let next = statesToCheck.popFirst() {
        let currDist = foundStates[next.from]! + 1
        
        if foundStates[next.to] == nil || foundStates[next.to]! > currDist {
          foundStates[next.to] = currDist
          for button in machine.buttons {
            statesToCheck.append((from: next.to, to: next.to ^ button))
          }
        }
      }
      
      sumOfPresses += foundStates[machine.target]!
    }
    
    return sumOfPresses
  }

  func part2() -> Any {
    let allMachines = data.split(separator: "\n").map(Machine.init(fromLine:))
    
    var sumOfPresses = 0
    
    for machine in allMachines {
      // Stores the state, and the depth to get there
      var statesToCheck: Deque<(from: [Int], to: [Int])> = []
      
      let startState = Array(repeating: 0, count: machine.joltageTargets.count)
      
      for button in machine.buttons {
        statesToCheck.append((from: startState, to: startState.incrementedWhereTrue(in: button)))
      }
      
      var foundStates: [[Int]: Int] = [.init(repeating: 0, count: machine.joltageTargets.count) : 0]
      
      while let next = statesToCheck.popFirst() {
        let currDist = foundStates[next.from]! + 1
        
        if foundStates[next.to] == nil || foundStates[next.to]! > currDist {
          foundStates[next.to] = currDist
          if next.to == machine.joltageTargets {
            continue
          }
          for button in machine.buttons {
            let result = next.to.incrementedWhereTrue(in: button)
            if result <= machine.joltageTargets {
                statesToCheck.prepend((from: next.to, to: result))
            }
          }
        }
      }
      
      sumOfPresses += foundStates[machine.joltageTargets]!
    }
    
    return sumOfPresses
  }
}
