//
//  FileOSLoggerCore.swift
//  LoggerKit
//
//  Created by XIAOCHUAN HE on R 7/07/28.
//

import Foundation
import os

public final class FileOSLoggerCore: LoggerCore {
    public let subsystem: String
    public let category: String
    private let fileUrl: URL?
    private let base64On: Bool

    let logger: os.Logger

    public init(
        subsystem: String,
        category: String,
        fileUrl: URL?,
        base64On: Bool = false
    ) {
        self.subsystem = subsystem
        self.category = category
        self.fileUrl = fileUrl
        self.base64On = base64On
        logger = os.Logger(subsystem: subsystem, category: category)
    }

    public func log(level: LogLevel, message: String, metadata: [String: String]?) {
        let osLogType: OSLogType = switch level {
        case .debug: .debug
        case .info: .info
        case .warning: .default
        case .error: .error
        }

        #if DEBUG
            let fullMessage = "\(message) in \(metadata?["function"] ?? "") at \(metadata?["file"] ?? ""):\(metadata?["line"] ?? "")"
            logger.log(level: osLogType, "\(fullMessage, privacy: .public)")
        #else
            if level > .debug {
                logger.log(level: osLogType, "\(message)")
            }
        #endif

        guard let fileUrl else { return }
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let logLine = "[\(timestamp)][\(subsystem)][\(category)] [\(level.rawValue.uppercased())] \(message)\n"
        let logLineData = base64On ? logLine.data(using: .utf8)?.base64EncodedData() : logLine.data(using: .utf8)
        #if DEBUG
            writeToFile(logLineData)
        #else
            if level > .debug {
                writeToFile(logLineData)
            }
        #endif
    }

    private func writeToFile(_ data: Data?) {
        guard let fileUrl, let data else { return }

        if let handle = try? FileHandle(forWritingTo: fileUrl) {
            handle.seekToEndOfFile()
            handle.write(data)
            handle.closeFile()
        } else {
            try? data.write(to: fileUrl, options: .atomic) // 初次写入
        }
    }
}
