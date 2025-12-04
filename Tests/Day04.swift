import Testing

@testable import AdventOfCode

struct Day04Tests {

  let testInput1 = """
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
    """

  @Test func testPart1() async throws {
    #expect(String(describing: Day04(data: testInput1).part1()) == "13")
  }

  @Test func testPart2() async throws {
    #expect(String(describing: Day04(data: testInput1).part2()) == "43")
  }
}
