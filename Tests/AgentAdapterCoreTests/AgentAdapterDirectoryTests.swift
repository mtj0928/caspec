import Foundation
import Testing
@testable import AgentAdapterCore

struct AgentAdapterDirectoryTests {
    @Test func buildsSourcePaths() {
        let rootPath = URL(fileURLWithPath: "/root")
        let directory = AgentAdapterDirectory(rootPath: rootPath)

        #expect(directory.specFilePath == rootPath.appendingPathComponent("AGENT_GUIDELINES.md"))
        #expect(directory.agentAdapterRootPath == rootPath.appendingPathComponent("agent-adapter"))
        #expect(directory.agentAdapterSkillsPath == rootPath.appendingPathComponent("agent-adapter/skills"))
        #expect(directory.agentAdapterAgentsPath == rootPath.appendingPathComponent("agent-adapter/agents"))
    }

    @Test func buildsToolOutputPaths() {
        let rootPath = URL(fileURLWithPath: "/root")
        let directory = AgentAdapterDirectory(rootPath: rootPath)

        let codexOutputs = directory.outputs(for: .codex)
        #expect(codexOutputs.specFilePath == rootPath.appendingPathComponent("AGENTS.md"))
        #expect(codexOutputs.skillsPath == rootPath.appendingPathComponent(".codex/skills"))
        #expect(codexOutputs.agentsPath == nil)

        let claudeOutputs = directory.outputs(for: .claude)
        #expect(claudeOutputs.specFilePath == rootPath.appendingPathComponent("CLAUDE.md"))
        #expect(claudeOutputs.skillsPath == rootPath.appendingPathComponent(".claude/skills"))
        #expect(claudeOutputs.agentsPath == rootPath.appendingPathComponent(".claude/agents"))
    }
}
