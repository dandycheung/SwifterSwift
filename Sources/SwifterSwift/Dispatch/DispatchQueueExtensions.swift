// DispatchQueueExtensions.swift - Copyright 2025 SwifterSwift

#if canImport(Dispatch)
import Dispatch

// MARK: - Properties

public extension DispatchQueue {
    #if !os(Linux) && !os(Android)
    /// SwifterSwift: A Boolean value indicating whether the current dispatch queue is the main queue.
    static var isMainQueue: Bool {
        enum Static {
            static let key: DispatchSpecificKey<Void> = {
                let key = DispatchSpecificKey<Void>()
                DispatchQueue.main.setSpecific(key: key, value: ())
                return key
            }()
        }
        return DispatchQueue.getSpecific(key: Static.key) != nil
    }
    #endif
}

// MARK: - Methods

public extension DispatchQueue {
    /// SwifterSwift: Returns a Boolean value indicating whether the current dispatch queue is the specified queue.
    ///
    /// - Parameter queue: The queue to compare against.
    /// - Returns: `true` if the current queue is the specified queue, otherwise `false`.
    static func isCurrent(_ queue: DispatchQueue) -> Bool {
        let key = DispatchSpecificKey<Void>()

        queue.setSpecific(key: key, value: ())
        defer { queue.setSpecific(key: key, value: nil) }

        return DispatchQueue.getSpecific(key: key) != nil
    }

    /// SwifterSwift: Runs passed closure asynchronous after certain time interval.
    ///
    /// - Parameters:
    ///   - delay: The time interval after which the closure will run.
    ///   - qos: Quality of service at which the work item should be executed.
    ///   - flags: Flags that control the execution environment of the work item.
    ///   - work: The closure to run after certain time interval.
    func asyncAfter(delay: Double,
                    qos: DispatchQoS = .unspecified,
                    flags: DispatchWorkItemFlags = [],
                    execute work: @Sendable @escaping () -> Void) {
        asyncAfter(deadline: .now() + delay, qos: qos, flags: flags, execute: work)
    }

    #if !os(Linux) && !os(Android)
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    func debounce(delay: Double, action: @escaping () -> Void) -> () -> Void {
        // http://stackoverflow.com/questions/27116684/how-can-i-debounce-a-method-call
        var lastFireTime = DispatchTime.now()
        let deadline = { lastFireTime + delay }
        return {
            self.asyncAfterUnsafe(deadline: deadline()) {
                let now = DispatchTime.now()
                if now >= deadline() {
                    lastFireTime = now
                    action()
                }
            }
        }
    }
    #endif
}

#endif
