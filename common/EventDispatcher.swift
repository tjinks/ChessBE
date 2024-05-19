//
//  File.swift
//  
//
//  Created by Tony on 24/01/2024.
//

import Foundation

public typealias EventHandler = (Any) -> ()

public let noopEventHandler: EventHandler = { _ in return }

public class EventDispatcher {
    private var handlers: [EventHandler] = []
    private var shuttingDown = false
    
    public init() {
        
    }
    
    public func register(_ handler: @escaping EventHandler) {
        if Thread.isMainThread {
            if shuttingDown {
                return
            }
            
            handlers.append(handler)
        } else {
            DispatchQueue.main.sync {
                register(handler)
            }
        }
    }
    
    public func dispatch(_ event: Any) {
        if Thread.isMainThread {
            if shuttingDown {
                return
            }
            
            for h in handlers {
                h(event)
            }
            
            if isShutdownInProgress(event) {
                handlers = []
                shuttingDown = true
            }
        } else {
            DispatchQueue.main.async {
                self.dispatch(event)
            }
        }
    }
}
