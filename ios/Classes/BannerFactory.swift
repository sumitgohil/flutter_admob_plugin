//
//  BannerFactory.swift
//  flutter_admob_plugin
//
//  Created by Sumit Gohil on 03/07/19.
//


import Flutter
import Foundation

class BannerFactory : NSObject, FlutterPlatformViewFactory {
    let messeneger: FlutterBinaryMessenger
    
    init(messeneger: FlutterBinaryMessenger) {
        self.messeneger = messeneger
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return AdmobBannerView(
            frame: frame,
            viewId: viewId,
            args: args as? [String : Any] ?? [:],
            messeneger: messeneger
        )
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
