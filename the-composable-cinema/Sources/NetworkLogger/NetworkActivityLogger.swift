//
//  NetworkActivityLogger.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 05/05/2024.
//

import Alamofire
import Foundation

/// The level of logging detail.
public enum NetworkActivityLoggerLevel {
    /// Do not log requests or responses.
    case off
    
    /// Logs HTTP method, URL, header fields, & request body for requests, and status code, URL, header fields, response string, & elapsed time for responses.
    case debug
    
    /// Logs HTTP method & URL for requests, and status code, URL, & elapsed time for responses.
    case info
    
    /// Logs HTTP method & URL for requests, and status code, URL, & elapsed time for responses, but only for failed requests.
    case warn
    
    /// Equivalent to `.warn`
    case error
    
    /// Equivalent to `.off`
    case fatal
}

/// `NetworkActivityLogger` logs requests and responses made by Alamofire.SessionManager, with an adjustable level of detail.
public class NetworkActivityLogger {
    // MARK: - Properties
    
    /// The shared network activity logger for the system.
    public static let shared = NetworkActivityLogger()
    
    /// The level of logging detail. See NetworkActivityLoggerLevel enum for possible values. .info by default.
    public var level: NetworkActivityLoggerLevel
    
    /// Omit requests which match the specified predicate, if provided.
    public var filterPredicate: NSPredicate?
    
    private let queue = DispatchQueue(label: "\(NetworkActivityLogger.self) Queue")
    
    // MARK: - Internal - Initialization
    
    init() {
        level = .info
    }
    
    deinit {
        stopLogging()
    }
    
    // MARK: - Logging
    
    /// Start logging requests and responses.
    public func startLogging() {
        stopLogging()
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(NetworkActivityLogger.requestDidStart(notification:)),
            name: Request.didResumeNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(NetworkActivityLogger.requestDidFinish(notification:)),
            name: Request.didFinishNotification,
            object: nil
        )
    }
    
    /// Stop logging requests and responses.
    public func stopLogging() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private - Notifications
    
    @objc private func requestDidStart(notification: Notification) {
        queue.async {
            guard let dataRequest = notification.request as? DataRequest,
                let task = dataRequest.task,
                let request = task.originalRequest,
                let httpMethod = request.httpMethod,
                let requestURL = request.url
                else {
                    return
            }
            
            if let filterPredicate = self.filterPredicate, filterPredicate.evaluate(with: request) {
                return
            }
            
            switch self.level {
            case .debug:
                let cURL = dataRequest.cURLDescription()
                
                self.logDivider()
                
                print("\(httpMethod) '\(requestURL.absoluteString)':")
                
                print("cURL:\n\(cURL)")
            case .info:
                self.logDivider()
                
                print("\(httpMethod) '\(requestURL.absoluteString)'")
            default:
                break
            }
        }
    }
    
    @objc private func requestDidFinish(notification: Notification) {
        queue.async {
            guard let dataRequest = notification.request as? DataRequest,
                let task = dataRequest.task,
                let metrics = dataRequest.metrics,
                let request = task.originalRequest,
                let httpMethod = request.httpMethod,
                let requestURL = request.url
                else {
                    return
            }
            
            if let filterPredicate = self.filterPredicate, filterPredicate.evaluate(with: request) {
                return
            }
            
            let elapsedTime = metrics.taskInterval.duration
            
            if let error = task.error {
                switch self.level {
                case .debug, .info, .warn, .error:
                    self.logDivider()
                    
                    print("[Error] \(httpMethod) '\(requestURL.absoluteString)' [\(String(format: "%.04f", elapsedTime)) s]:")
                    print(error)
                default:
                    break
                }
            } else {
                guard let response = task.response as? HTTPURLResponse else {
                    return
                }
                
                switch self.level {
                case .debug:
                    self.logDivider()
                    
                    print("\(String(response.statusCode)) '\(requestURL.absoluteString)' [\(String(format: "%.04f", elapsedTime)) s]:")
                    
                    self.logHeaders(headers: response.allHeaderFields)
                    
                    guard let data = dataRequest.data else { break }
                    
                    print("Body:")
                    
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                        
                        if let prettyString = String(data: prettyData, encoding: .utf8) {
                            print(prettyString)
                        }
                    } catch {
                        if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                            print(string)
                        }
                    }
                case .info:
                    self.logDivider()
                    
                    print("\(String(response.statusCode)) '\(requestURL.absoluteString)' [\(String(format: "%.04f", elapsedTime)) s]")
                default:
                    break
                }
            }
        }
        
    }
}

private extension NetworkActivityLogger {
    func logDivider() {
        print("---------------------")
    }
    
    func logHeaders(headers: [AnyHashable : Any]) {
        print("Headers: [")
        for (key, value) in headers {
            print("  \(key): \(value)")
        }
        print("]")
    }
}
