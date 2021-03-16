//
//  NetworkLayer.swift
//  Weather
//
//  Created by Thiyagu  on 16/03/21.
//  Copyright © 2021 Thiyagu . All rights reserved.
//

import Foundation

// data request type
enum NetworkRequest: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

typealias successBlock = ((Any?) -> Void)
typealias failureBlock = ((Any?) -> Void)

final class NetworkLayer {
    
    // MARK: - GET Request
    class func getData(url: URL, successBlock: successBlock?, failed failureBlock: failureBlock? ) {
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil {
                successBlock?(data)
            } else {
                failureBlock?(error)
            }
        }
        session.resume()
    }
}
