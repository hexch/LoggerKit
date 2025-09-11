//
//  File.swift
//  LoggerKit
//
//  Created by XIAOCHUAN HE on R 7/06/27.
//

import Foundation
import os

public final class OSLoggerCore: LoggerCore {
    public let subsystem: String
    public let category: String
    let logger: os.Logger
    
    public init(subsystem: String, category: String) {
        self.subsystem = subsystem
        self.category = category
        self.logger = os.Logger(subsystem: subsystem, category: category)
    }
    
    public func log(level: LogLevel, message: String, metadata: [String : String]?) {
        let osLogType: OSLogType = {
            switch level {
            case .debug: return .debug
            case .info: return .info
            case .warning: return .default
            case .error: return .error
            }
        }()
        
        
#if DEBUG
        let fullMessage = "\(message) in \(metadata?["function"] ?? "") at \(metadata?["file"] ?? ""):\(metadata?["line"] ?? "")"
        logger.log(level: osLogType, "\(fullMessage, privacy: .public)")
#else
        if level > .debug {
            logger.log(level: osLogType, "\(message)")
        }
#endif
    }
}
