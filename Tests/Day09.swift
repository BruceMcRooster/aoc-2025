import Testing

@testable import AdventOfCode

struct Day09Tests {

  let testInput1 = """
    7,1
    11,1
    11,7
    9,7
    9,5
    2,5
    2,3
    7,3
    """

  @Test func testPart1() async throws {
    #expect(String(describing: Day09(data: testInput1).part1()) == "50")
    #expect(String(describing: Day09(data: somewhatProblematicInput).part1()) == "121")
    #expect(String(describing: Day09(data: potentiallyReallyProblematicInput).part1()) == "100")
  }

  /*
   ┌────────────┐
   └───────────┐│
               ││
               ││
               ││
               ││
               ││
               └┘
   Credit to https://www.reddit.com/r/adventofcode/comments/1pi3hff/comment/nt3qgh7/
   */
  let somewhatProblematicInput = """
    1,1
    11,1
    11,11
    10,11
    10,2
    1,2
    """
  /*
    ┌────────┐
    │┌──────┐│
    ││      ││
    ││      ││
    ││      ││
    ││      ││
    └┘      ││
       ┌────┘│
    ┌──┘     │
    └────────┘
   */
  // I'm worried that something will detect the inner rectangle formed by (2,2)x(9,7) or (2,7)x(9,2) (area 48)
  // instead of the actual largest internal rectangle at the base with area 21
  // simply raycasting doesn't work, since all points will hit a red or green tile before making it out
  let potentiallyReallyProblematicInput = """
    1,1
    10,1
    10,10
    1,10
    1,9
    4,9
    4,8
    9,8
    9,2
    2,2
    2,7
    1,7
    """
  
  @Test func testPart2() async throws {
    #expect(String(describing: Day09(data: testInput1).part2()) == "24")
    #expect(String(describing: Day09(data: somewhatProblematicInput).part2()) == "22")
    #expect(String(describing: Day09(data: potentiallyReallyProblematicInput).part2()) == "21")
  }
}
