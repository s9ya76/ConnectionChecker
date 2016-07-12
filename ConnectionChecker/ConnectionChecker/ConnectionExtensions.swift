//
//  ConnectionExtensions.swift
//  ConnectionChecker
//
//  Created by 關貿開發者 on 2016/7/12.
//  Copyright © 2016年 關貿開發者. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

public extension UIDevice {
    
    // 是否連線到網路
    func isConnectedNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            print("網路尚未連線")
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
    }
}

public extension UIViewController {
    
    public func isConnectedNetwork(connectionChange: (isConnectedNetwork: Bool) -> Void) {
        var isConnectedNetwork :Bool?
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            while true {
                if(!self.isTopViewController) {
                    print("Stop get network connection state.")
                    break
                }
                
                let isConnectedNetworkCurrent = UIDevice().isConnectedNetwork()
                if(isConnectedNetwork != isConnectedNetworkCurrent) {
                    isConnectedNetwork = isConnectedNetworkCurrent
                    dispatch_async(dispatch_get_main_queue()) {
                        connectionChange(isConnectedNetwork: isConnectedNetwork!)
                    }
                }
                sleep(3)
            }
        }
    }
    
    public var isVisible: Bool {
        if isViewLoaded() {
            return view.window != nil
        }
        return false
    }
    
    public var isTopViewController: Bool {
        if self.navigationController != nil {
            return self.navigationController?.visibleViewController === self
        } else if self.tabBarController != nil {
            return self.tabBarController?.selectedViewController == self && self.presentedViewController == nil
        } else {
            return self.presentedViewController == nil && self.isVisible
        }
    }
}
