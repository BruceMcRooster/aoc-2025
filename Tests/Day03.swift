import Testing

@testable import AdventOfCode

struct Day03Tests {

  let testInput1 = """
    987654321111111
    811111111111119
    234234234234278
    818181911112111
    """

  @Test func testPart1() async throws {
    #expect(String(describing: Day03(data: testInput1).part1()) == "357")
  }

  @Test func testPart2() async throws {
    #expect(true)
  }
}
