import Testing
@testable import CASpecCore

struct CASpecGitignoreTests {
    @Test func renderGroupsEntriesWithToolComments() {
        let custom = Tool(
            name: "custom",
            instructionsFile: "CUSTOM.md",
            skillsDirectory: ".custom/skills",
            subagentsDirectory: ".custom/subagents"
        )

        let output = CASpecGitignore.render(for: [custom, .claude])

        #expect(output == """
        # custom
        CUSTOM.md
        .custom/skills/
        .custom/subagents/

        # claude
        CLAUDE.md
        .claude/skills/
        .claude/subagents/
        """)
    }

    @Test func toolsForGitignoreUsesOnlyTargets() throws {
        let config = CASpecConfiguration(tools: [
            Tool(
                name: "custom",
                instructionsFile: "CUSTOM.md",
                skillsDirectory: ".custom/skills",
                subagentsDirectory: nil
            )
        ])

        let tools = try CASpecGitignore.toolsForGitignore(
            targetToolNames: ["codex"],
            config: config
        )

        #expect(tools.map(\.name) == ["codex"])
    }

    @Test func toolsForGitignoreReturnsEmptyForNoTargets() throws {
        let tools = try CASpecGitignore.toolsForGitignore(
            targetToolNames: [],
            config: nil
        )

        #expect(tools.isEmpty)
    }

    @Test func toolsForGitignoreThrowsOnUnknownTargets() {
        #expect(throws: CASpecGitignore.CASpecGitignoreError.self) {
            try CASpecGitignore.toolsForGitignore(
                targetToolNames: ["missing"],
                config: nil
            )
        }
    }
}
