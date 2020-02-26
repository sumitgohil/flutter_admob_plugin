import Flutter
import UIKit
import GoogleMobileAds


public class SwiftFlutterAdmobPlugin: NSObject, FlutterPlugin{
  
    
//    let frame : CGRect
//    let viewId : Int64
//    var bannerView: GADBannerView!
//
    
//    public func view() -> UIView {
//
//         bannerView = GADBannerView(adSize: kGADAdSizeBanner)
//        bannerView.adUnitID =  "ca-app-pub-3940256099942544/2934735716"
//        bannerView.rootViewController = UIApplication.shared.keyWindow?.rootViewController
//        bannerView.frame = self.frame.width == 0 ? CGRect(x: 0, y: 0, width: 1, height: 1) : self.frame
//        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID]
//            bannerView.load(request)
//        return bannerView
//    }
//
//    init(_ frame: CGRect, viewId: Int64, args: Any?){
//        self.frame = frame
//        self.viewId = viewId
//    }
    
    
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SwiftFlutterAdmobPlugin()
    
    let defaultChannel = FlutterMethodChannel(name: "admob", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(instance, channel: defaultChannel)

    
    registrar.register(
        BannerFactory(messeneger: registrar.messenger()),
        withId: "admob/banner"
    )
  
    
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "getPlatformVersion") {
        result("iOS " + UIDevice.current.systemVersion)
    }
    else if (call.method == "showAlertDialog") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Alert", message: "Hi, My name is flutter", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil);
        }
    
    }
    else if (call.method == "initAdmob") {
        DispatchQueue.main.async {
            
            
           GADMobileAds.sharedInstance().start(completionHandler: nil)
            print("Admob Initiated")

        }
        
    }
  }
    
    
}


