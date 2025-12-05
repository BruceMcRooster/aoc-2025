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

  @Test func testPart1() async throws {
    #expect(String(describing: Day05(data: testInput1).part1()) == "3")
  }

  @Test func testPart2() async throws {
    #expect(true)
  }
}
