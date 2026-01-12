import Foundation
import Testing
@testable import CASpecCore

struct CASpecConfigurationTests {
    @Test func loadsCustomToolsFromYaml() throws {
        let rootPath = URL(fileURLWithPath: "/root")
        let fileSystem = InMemoryFileSystem()
        try fileSystem.createDirectory(at: rootPath, withIntermediateDirectories: true)
        try fileSystem.writeString(
            """
            tools:
              - name: codex
                outputFileName: CUSTOM.md
                skillsFolderName: .custom/skills
              - name: cortex
                outputFileName: CORTEX.md
                skillsFolderName: .cortex/skills
                subagentsFolderName: .cortex/subagents
            """,
            to: rootPath.appendingPathComponent(".caspec.yml"),
            atomically: true,
            encoding: .utf8
        )

        let config = try CASpecConfiguration.load(from: rootPath, fileSystem: fileSystem)
        let resolved = try #require(config?.resolvedTools())

        #expect(resolved["claude"] != nil)
        let codex = try #require(resolved["codex"])
        #expect(codex.outputFileName == "CUSTOM.md")
        #expect(codex.skillsFolderName == ".custom/skills")
        #expect(codex.subagentsFolderName == nil)

        let cortex = try #require(resolved["cortex"])
        #expect(cortex.outputFileName == "CORTEX.md")
        #expect(cortex.subagentsFolderName == ".cortex/subagents")
    }
}
