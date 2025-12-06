import Testing

@testable import AdventOfCode

struct Day06Tests {

  let testInput1 = """
    123 328  51 64 
     45 64  387 23 
      6 98  215 314
    *   +   *   +  
    """

  @Test func testPart1() async throws {
    #expect(String(describing: Day06(data: testInput1).part1()) == "4277556")
  }

  @Test func testPart2() async throws {
    #expect(true)
  }
}
