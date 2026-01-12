import Foundation
import Yams

/// Configuration stored in `.caspec.yml` for defining custom tools.
public struct CASpecConfiguration: Sendable, Decodable {
    /// Tool definitions provided by the configuration file.
    public let tools: [Tool]

    /// Creates a configuration with the provided tools.
    public init(tools: [Tool]) {
        self.tools = tools
    }
}

extension CASpecConfiguration {
    /// The default configuration file name.
    public static let fileName = ".caspec.yml"

    /// Loads configuration from the provided root path if a config file exists.
    public static func load(from rootPath: URL, fileSystem: FileSystem) throws -> CASpecConfiguration? {
        let configPath = rootPath.appendingPathComponent(fileName)
        guard fileSystem.fileExists(atPath: configPath.path) else { return nil }
        let contents = try fileSystem.readString(at: configPath, encoding: .utf8)
        let decoder = YAMLDecoder()
        return try decoder.decode(CASpecConfiguration.self, from: contents)
    }

    /// Merges configuration tools with the provided defaults, overriding by name.
    public func resolvedTools(defaults: [Tool] = Tool.defaults) -> [String: Tool] {
        var resolved = Dictionary(uniqueKeysWithValues: defaults.map { ($0.name, $0) })
        for tool in tools {
            resolved[tool.name] = tool
        }
        return resolved
    }
}
