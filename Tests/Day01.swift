import Testing

@testable import AdventOfCode

struct Day01Tests {

  let testInput1 = """
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
    """

  @Test func testPart1() async throws {
    #expect(String(describing: Day01(data: testInput1).part1()) == "3")
  }

  @Test func testPart2() async throws {
    #expect(String(describing: Day01(data: testInput1).part2()) == "6")
  }
}
