//
//  SwiftyLogger.swift
//  QuantumLeap
//
//  Created by devonly on 2025/08/01.
//  Copyright © 2025 QuantumLeap. All rights reserved.
//

@preconcurrency
import Foundation
import SwiftyBeaver

public enum SwiftyLogger: Sendable {
    private static let logger: SwiftyBeaver.Type = SwiftyBeaver.self
    private static let console: ConsoleDestination = {
        let destination: ConsoleDestination = .init(format: "$DHH:mm:ss$d $L: $M")
        #if targetEnvironment(simulator) || DEBUG
        destination.minLevel = .debug
        #else
        destination.minLevel = .warning
        #endif
        destination.useNSLog = true
        destination.useTerminalColors = true
        return destination
    }()

    private static let file: FileDestination = {
        let dateFormatter: DateFormatter = .init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let manager: FileManager = .default
        let destination: FileDestination = .init(format: "$DHH:mm:ss$d $L: $M")
        #if targetEnvironment(simulator) || DEBUG
        destination.minLevel = .debug
        #else
        destination.minLevel = .info
        #endif
        destination.logFileAmount = 256
        destination.logFileMaxSize = 1 * 1_024 * 1_024
        destination.logFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent("logs", isDirectory: true)
            .appendingPathComponent("\(dateFormatter.string(from: .now)).log", isDirectory: false)
        destination.colored = true
        destination.syncAfterEachWrite = true
        return destination
    }()

    public static func configure(
        format _: String = "$DHH:mm:ss$d $L: $M",
        logFileAmount _: Int = 10,
        logFileMaxSize _: Int = 1 * 1_024 * 1_024,
        useNSLog: Bool = false,
        userTerminalColors: Bool = false,
        colored: Bool = false,
    ) {
        logger.addDestination(console)
        logger.addDestination(file)
    }

    public static func info(_ message: Any, context: Any? = nil) {
        logger.info(message, context: context)
    }

    public static func error(_ message: Any, context: Any? = nil) {
        logger.error(message, context: context)
    }

    public static func debug(_ message: Any, context: Any? = nil) {
        logger.debug(message, context: context)
    }

    public static func warning(_ message: Any, context: Any? = nil) {
        logger.warning(message, context: context)
    }

    public static func verbose(_ message: Any, context: Any? = nil) {
        logger.verbose(message, context: context)
    }

    @discardableResult
    public static func deleteLogFile() -> Bool {
        guard
            let destination: FileDestination = logger.destinations.compactMap({ $0 as? FileDestination })
            .first
        else {
            return false
        }
        return destination.deleteLogFile()
    }
}

extension ConsoleDestination {
    convenience init(format: String) {
        self.init()
        self.format = format
        minLevel = .verbose
    }
}

extension FileDestination {
    convenience init(format: String) {
        self.init()
        self.format = format
        minLevel = .info
    }
}
