import Testing
@testable import CASpecCore

struct DummyTest {
    @Test func dummy() async throws {
        #expect(Dummy.string == "Hello")
    }

}
