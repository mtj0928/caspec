import Foundation

/// Generates tool-specific documentation and configuration files from `CASPEC.md`.
public struct CASpecGenerator {
    private let fileManager: FileManager

    /// Creates a generator with the provided file manager.
    /// - Parameter fileManager: The file manager used for filesystem operations.
    public init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    /// Generates tool-specific outputs in the given project root.
    /// - Parameters:
    ///   - rootPath: The project root containing `CASPEC.md`.
    ///   - tool: The tool variant to generate.
    public func generate(in rootPath: URL, tool: Tool) throws {
        let directory = CASpecDirectory(rootPath: rootPath)
        let outputs = directory.outputs(for: tool)
        let specContents = try String(contentsOf: directory.specFilePath, encoding: .utf8)
        let filteredSpec = filterContents(specContents, tool: tool)
        try writeSpecOutput(filteredSpec, to: outputs)

        try generateSkills(from: directory, outputs: outputs, tool: tool)
        try generateSubagents(from: directory, outputs: outputs, tool: tool)
    }
}

private extension CASpecGenerator {
    func writeSpecOutput(_ contents: String, to outputs: CASpecDirectory.ToolOutputs) throws {
        try contents.write(to: outputs.specFilePath, atomically: true, encoding: .utf8)
    }

    func generateSkills(
        from directory: CASpecDirectory,
        outputs: CASpecDirectory.ToolOutputs,
        tool: Tool
    ) throws {
        let sourcePath = directory.caspecSkillsPath
        guard fileManager.fileExists(atPath: sourcePath.path),
              let destinationPath = outputs.skillsPath else { return }
        try copyDirectoryContents(from: sourcePath, to: destinationPath, tool: tool)
    }

    func generateSubagents(
        from directory: CASpecDirectory,
        outputs: CASpecDirectory.ToolOutputs,
        tool: Tool
    ) throws {
        let sourcePath = directory.caspecSubagentsPath
        guard fileManager.fileExists(atPath: sourcePath.path),
              let destinationPath = outputs.subagentsPath else { return }
        try copyDirectoryContents(from: sourcePath, to: destinationPath, tool: tool)
    }

    func copyDirectoryContents(from sourcePath: URL, to destinationPath: URL, tool: Tool) throws {
        if !fileManager.fileExists(atPath: destinationPath.path) {
            try fileManager.createDirectory(at: destinationPath, withIntermediateDirectories: true)
        }

        let items = try fileManager.contentsOfDirectory(
            at: sourcePath,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: []
        )
        for itemPath in items {
            let resourceValues = try itemPath.resourceValues(forKeys: [.isDirectoryKey])
            let destinationItemPath = destinationPath.appendingPathComponent(itemPath.lastPathComponent)

            if resourceValues.isDirectory ?? false {
                try copyDirectoryContents(from: itemPath, to: destinationItemPath, tool: tool)
            } else {
                try writeFilteredFile(from: itemPath, to: destinationItemPath, tool: tool)
            }
        }
    }

    func writeFilteredFile(from sourcePath: URL, to destinationPath: URL, tool: Tool) throws {
        try fileManager.createDirectory(
            at: destinationPath.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )

        if let data = try? Data(contentsOf: sourcePath),
           let text = String(data: data, encoding: .utf8) {
            let filtered = filterContents(text, tool: tool)
            try filtered.write(to: destinationPath, atomically: true, encoding: .utf8)
            return
        }

        if fileManager.fileExists(atPath: destinationPath.path) {
            try fileManager.removeItem(at: destinationPath)
        }
        try fileManager.copyItem(at: sourcePath, to: destinationPath)
    }

    func filterContents(_ contents: String, tool: Tool) -> String {
        enum BlockState {
            case all
            case toolSpecific(String)
        }

        var state = BlockState.all
        var output: [String] = []
        let lines = contents.split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)

        for lineSubsequence in lines {
            let line = String(lineSubsequence)
            if let startTool = CASPECFormat.parseBlockStart(line: line) {
                state = .toolSpecific(startTool)
                continue
            }

            if CASPECFormat.isBlockEnd(line: line) {
                state = .all
                continue
            }

            switch state {
            case .all:
                output.append(line)
            case .toolSpecific(let blockToolName) where blockToolName == tool.name:
                output.append(line)
            case .toolSpecific:
                break
            }
        }

        return output.joined(separator: "\n")
    }
}
