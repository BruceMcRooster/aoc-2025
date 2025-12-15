import Testing

@testable import AdventOfCode

struct Day11Tests {

  let testInput1 = """
    aaa: you hhh
    you: bbb ccc
    bbb: ddd eee
    ccc: ddd eee fff
    ddd: ggg
    eee: out
    fff: out
    ggg: out
    hhh: ccc fff iii
    iii: out
    """

  let testInput2 = """
    svr: aaa bbb
    aaa: fft
    fft: ccc
    bbb: tty
    tty: ccc
    ccc: ddd eee
    ddd: hub
    hub: fff
    eee: dac
    dac: fff
    fff: ggg hhh
    ggg: out
    hhh: out
    """
  
  @Test func testPart1() async throws {
    #expect(String(describing: Day11(data: testInput1).part1()) == "5")
  }

  @Test func testPart2() async throws {
    #expect(String(describing: Day11(data: testInput2).part2()) == "2")
  }
}
