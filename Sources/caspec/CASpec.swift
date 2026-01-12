import ArgumentParser
import CASpecCore
import Foundation

@main
struct CASpec: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "caspec",
        subcommands: [Generate.self, GenerateGitignore.self],
        defaultSubcommand: Generate.self
    )

    struct Generate: AsyncParsableCommand {
        @Argument(help: "Target tool to generate (codex, claude, or custom from .caspec.yml).")
        var target: String

        mutating func run() async throws {
            let fileSystem = FileManager.default
            let generator = CASpecGenerator()
            let rootPath = URL(fileURLWithPath: fileSystem.currentDirectoryPath)
            let config = try CASpecConfiguration.load(from: rootPath, fileSystem: fileSystem)
            let toolsByName = config?.resolvedTools() ?? Dictionary(uniqueKeysWithValues: Tool.defaults.map { ($0.name, $0) })
            guard let tool = toolsByName[target] else {
                let available = toolsByName.keys.sorted().joined(separator: ", ")
                throw ValidationError("Unknown tool '\(target)'. Available tools: \(available)")
            }
            try generator.generate(in: rootPath, tool: tool)
        }
    }

    struct GenerateGitignore: ParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "generate-gitignore"
        )

        @Argument(help: "Tool names to include alongside tools from .caspec.yml.")
        var targets: [String] = []

        mutating func run() throws {
            let fileSystem = FileManager.default
            let rootPath = URL(fileURLWithPath: fileSystem.currentDirectoryPath)
            let config = try CASpecConfiguration.load(from: rootPath, fileSystem: fileSystem)
            let tools = try CASpecGitignore.toolsForGitignore(
                targetToolNames: targets,
                config: config
            )
            print(CASpecGitignore.render(for: tools))
        }
    }
}
