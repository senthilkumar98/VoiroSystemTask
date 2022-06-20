//
//  CommonFunction.swift
//  VoiroSystemTask
//
//  Created by Senthil Kumar T on 20/06/22.
//

import Foundation
import UIKit
import SystemConfiguration


//MARK:- URL TO IMAGE DATA
extension UIImageView {
    func setImage(with urlString : String?,placeHolder placeHolderImage : UIImage?) {
        
        guard urlString != nil, let imageUrl = URL(string: urlString!) else {
            self.image = placeHolderImage
            return
        }
        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            guard data != nil, let imagePic = UIImage(data: data!) else {
                DispatchQueue.main.async {
                    self.image = placeHolderImage
                }
                return
            }
            DispatchQueue.main.async {
                self.image = imagePic
            }
        }.resume()
    }
}


public class Reachability {
    public func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        if flags.isEmpty {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return (isReachable && !needsConnection)
    }
}
