//
//  HawkClient.swift
//  SwiftyHawk
//
//  Created by Christoph Pageler on 18.11.17.
//

import Foundation


extension Hawk {

    public class Client {
        
        /// <#Description#>
        ///
        /// - Returns: (Header, Artifacts)
        public static func header(uri: String, method: String) -> (String, [String: String]) {
            return ("", [:])
        }
        
    }
    
}
