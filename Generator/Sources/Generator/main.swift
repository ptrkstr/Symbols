import Foundation

private struct Generator {
    
    private let currentDirectory = URL(fileURLWithPath: #file, isDirectory: false).deletingLastPathComponent()
    private var sourceDirectory: URL { currentDirectory.appendingPathComponent("../../../Sources/Symbols/Generated/") }
    private var testDirectory: URL { currentDirectory.appendingPathComponent("../../../Tests/SymbolsTests/Generated/") }
    private let generation = Date()
    
    private func header() -> String {
        """
        // Generated on \(generation)
        // Manual modifications will be overwitten.
        // Files are split up as Xcode lags when reading 3000+ line files.
        """
    }
    
    private func deleteExistingFiles(in directory: URL) throws {
        let fm = FileManager.default
        let filePaths = try fm.contentsOfDirectory(atPath: directory.path)
        for filePath in filePaths {
            let path = directory.appendingPathComponent(filePath).path
            try fm.removeItem(atPath: path)
        }
    }
    
    private func persistSymbols() throws {
        let symbols = try String(
            contentsOf: Bundle.module.url(forResource: "raw", withExtension: "txt")!
        ).split(separator: "\n").sorted()
        
        let nameAvailability: NameAvailability = try {
            let file = Bundle.module.url(forResource: "name_availability", withExtension: "plist")!
            let data = try Data(contentsOf: file)
            return try PropertyListDecoder().decode(NameAvailability.self, from: data)
        }()
        
        var lines = ""
        var tests = ""
        var lineCounter = 0
                
        for symbol in symbols {
            lineCounter += 1
            let name = symbol.camelized
            let yearToRelease = nameAvailability.yearToRelease(for: String(symbol))
            lines.append("    \(yearToRelease) static var \(name): String { \"\(symbol)\" }\n")
            
            // Workaround until github actions supports macos-12 https://github.com/actions/virtual-environments/issues/3649
            if yearToRelease.macOS == "12.0" {
                tests.append("        if #available(macOS 12.0, *) {\n    ")
            }
            tests.append("        XCTAssertNotNil(NSImage(systemSymbolName: String.Symbols.\(name), accessibilityDescription: nil))\n")
            if yearToRelease.macOS == "12.0" {
                tests.append("        }\n")
            }
            
            if lineCounter % 200 == 0 {
                do {
                    let string =
                    """
                    \(header())
                    
                    public extension String.Symbols {\n\(lines)}
                    """
                    
                    try persist(string, directory: sourceDirectory, filename: "Symbols+\(lineCounter).swift")
                    
                    lines = ""
                }
                
                do {
                    let string =
                    """
                    \(header())
                    
                    import XCTest
                    @testable import Symbols
                    
                    #if os(macOS)
                    
                    final class Symbols_\(lineCounter)_Tests: XCTestCase {
                        
                        @available(macOS 11.3, *)
                        func test() throws {\n\(tests)    }
                    }
                    
                    #endif
                    """
                    
                    try persist(string, directory: testDirectory,  filename: "Symbols+\(lineCounter)_Tests.swift")
                    
                    tests = ""
                }
            }
        }
    }
    
    private func persist(_ string: String, directory: URL, filename: String) throws {
        let writeURL = directory.appendingPathComponent("\(filename)")
        log("Saving `\(writeURL)`")
        let data = string.data(using: .utf8)!
        try data.write(to: writeURL)
    }
    
    func generate() throws {
        try deleteExistingFiles(in: sourceDirectory)
        try deleteExistingFiles(in: testDirectory)
        try persistSymbols()
    }
}

private let badChars = CharacterSet.alphanumerics.inverted

private extension String {
    var uppercasingFirst: String {
        return prefix(1).uppercased() + dropFirst()
    }

    var lowercasingFirst: String {
        return prefix(1).lowercased() + dropFirst()
    }
}

private extension String.SubSequence {

    var camelized: String {
        guard !isEmpty else {
            return ""
        }

        let parts = self.components(separatedBy: badChars)
        let first = parts.first!.lowercasingFirst
        let rest = parts.dropFirst().map { $0.uppercasingFirst }

        var final = ([first] + rest).joined(separator: "")
        
        if ["case", "return", "repeat"].contains(final) {
            return "`\(final)`"
        }
        
        if final.first?.isLetter == false {
            final = "_" + final
        }
        
        return final
    }
}

func log(_ string: String) {
    print("Generator: \(string)")
}

do {
    log("Started")
    try Generator().generate()
    log("Finished")
    exit(EXIT_SUCCESS)
} catch {
    log("ERROR - \(error.localizedDescription)")
    exit(EXIT_FAILURE)
}
RunLoop.main.run()
