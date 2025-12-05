import Testing

@testable import AdventOfCode

struct Day05Tests {

  let testInput1 = """
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32
    """
  
  let overlappingSingleRangesTestInput = """
    1-7
    7-7
    8-10
    10-12
    12-12
    12-15
    16-19
    
    5
    9
    11
    12
    20
    """

  @Test func testPart1() async throws {
    #expect(String(describing: Day05(data: testInput1).part1()) == "3")
    #expect(String(describing: Day05(data: overlappingSingleRangesTestInput).part1()) == "4")
  }

  @Test func testPart2() async throws {
    #expect(String(describing: Day05(data: testInput1).part2()) == "14")
    #expect(String(describing: Day05(data: overlappingSingleRangesTestInput).part2()) == "19")
  }
}
