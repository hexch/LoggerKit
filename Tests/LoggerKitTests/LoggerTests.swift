
import Testing
@testable import LoggerKit
import Foundation

// Mock LoggerCore for testing purposes
class MockLoggerCore: LoggerCore, @unchecked Sendable {
    var subsystem: String
    var category: String
    
    var lastLoggedMessage: String?
    var lastLogLevel: LogLevel?
    var lastLoggedMetadata: [String: String]?
    
    init(subsystem: String = "test.subsystem", category: String = "test.category") {
        self.subsystem = subsystem
        self.category = category
    }
    
    func log(level: LogLevel, message: String, metadata: [String : String]?) {
        lastLogLevel = level
        lastLoggedMessage = message
        lastLoggedMetadata = metadata
    }
}
@Suite("LoggerTests")
struct LoggerTests {
    // Tests the comparable implementation of the LogLevel enum.
    @Test func testLogLevelComparable() {
        #expect(LogLevel.debug < LogLevel.info)
        #expect(LogLevel.info < LogLevel.warning)
        #expect(LogLevel.warning < LogLevel.error)
        #expect(LogLevel.debug < LogLevel.error)
    }
    
    // Tests the basic logging functionality of the Logger class.
    @Test func testLogger() async throws {
        let mockCore = MockLoggerCore()
        let logger = Logger(core: mockCore)
        
        let message = "Test message"
        let file = "TestFile.swift"
        let function = "testFunction()"
        let line = 123
        
        logger.log(message, level: .info, file: file, function: function, line: line)
        
        // Wait for the async block to execute
        try await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(mockCore.lastLogLevel == .info)
        #expect(mockCore.lastLoggedMessage == message)
        #expect(mockCore.lastLoggedMetadata?["file"] == "TestFile.swift")
        #expect(mockCore.lastLoggedMetadata?["function"] == "testFunction()")
        #expect(mockCore.lastLoggedMetadata?["line"] == "123")
    }
    
    // Tests the convenience methods (debug, info, warning, error) of the Logger class.
    @Test func testLoggerConvenienceMethods() async throws {
        let mockCore = MockLoggerCore()
        let logger = Logger(core: mockCore)
        
        logger.debug("debug message")
        try await Task.sleep(nanoseconds: 100_000_000)
        #expect(mockCore.lastLogLevel == .debug)
        #expect(mockCore.lastLoggedMessage == "debug message")
        
        logger.info("info message")
        try await Task.sleep(nanoseconds: 100_000_000)
        #expect(mockCore.lastLogLevel == .info)
        #expect(mockCore.lastLoggedMessage == "info message")
        
        logger.warning("warning message")
        try await Task.sleep(nanoseconds: 100_000_000)
        #expect(mockCore.lastLogLevel == .warning)
        #expect(mockCore.lastLoggedMessage == "warning message")
        
        logger.error("error message")
        try await Task.sleep(nanoseconds: 100_000_000)
        #expect(mockCore.lastLogLevel == .error)
        #expect(mockCore.lastLoggedMessage == "error message")
    }
}
