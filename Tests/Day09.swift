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
  }

  @Test func testPart2() async throws {
    #expect(true)
  }
}
