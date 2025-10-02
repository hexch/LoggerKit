//
//  Logger.swift
//  LoggerKit
//
//  Created by XIAOCHUAN HE on R 7/06/27.
//

import Foundation

public final class Logger: LoggerProtocol, Sendable {
    let core: LoggerCore
    let queue: DispatchQueue

    public init(
        core: LoggerCore,
        qos: DispatchQoS = .utility
    ) {
        self.core = core
        queue = DispatchQueue(label: core.subsystem, qos: qos)
    }

    public func log(
        _ message: String,
        level: LogLevel = .debug,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        queue.async {
            let metadata = [
                "file": (file as NSString).lastPathComponent,
                "function": function,
                "line": String(line),
            ]
            self.core.log(level: level, message: message, metadata: metadata)
        }
    }
}
