//
//  LogLevel.swift
//  LoggerKit
//
//  Created by XIAOCHUAN HE on R 7/06/27.
//

import Foundation
public protocol LoggerCore: Sendable {
    /// The subsystem name.
    var subsystem: String { get }
    /// The category name
    var category: String { get }
    
    /// Logs a message with the specified level, message, and metadata.
    ///
    /// - Parameters:
    ///   - level: The log level.
    ///   - message: The message to log.
    ///   - metadata: The metadata to log.
    func log(level: LogLevel, message: String, metadata: [String: String]?)
}
