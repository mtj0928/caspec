import ArgumentParser

@main
struct CASpec: AsyncParsableCommand {
    mutating func run() async throws {
        print("Hello, world!")
    }
}
