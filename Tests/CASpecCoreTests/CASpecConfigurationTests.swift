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
                skillsDirectoryName: .custom/skills
              - name: cortex
                outputFileName: CORTEX.md
                skillsDirectoryName: .cortex/skills
                subagentsDirectoryName: .cortex/subagents
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
        #expect(codex.skillsDirectoryName == ".custom/skills")
        #expect(codex.subagentsDirectoryName == nil)

        let cortex = try #require(resolved["cortex"])
        #expect(cortex.outputFileName == "CORTEX.md")
        #expect(cortex.subagentsDirectoryName == ".cortex/subagents")
    }
}
