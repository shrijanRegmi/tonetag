import Flutter
import UIKit

public class TonetagPlugin: NSObject, FlutterPlugin {
    let KEY = "b8fe72d954aa9bf7261e3c2f2b145b0befb61a54a8a7f1bb17c749cc92b2ada0"
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "tonetag", binaryMessenger: registrar.messenger())
        let instance = TonetagPlugin()›
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "initializeTonetag":
                initializeTonetag(call, result)
            case "startSendingData":
                startSendingData(call, result)
            case "stopSendingData":
                stopSendingData(call, result)
            case "startReceivingData":
                startReceivingData(call, result)
            case "stopReceivingData":
                stopReceivingData(call, result)
            default:
        }
    }
    
    func initializeTonetag(call: FlutterMethodCall, result: @escaping FlutterResult) {
        Toast.show("")
    }
    
    func startSendingData(call: FlutterMethodCall, result: @escaping FlutterResult) {}
    
    func stopSendingData(call: FlutterMethodCall, result: @escaping FlutterResult) {}
    
    func startReceivingData(call: FlutterMethodCall, result: @escaping FlutterResult) {}
    
    func stopReceivingData(call: FlutterMethodCall, result: @escaping FlutterResult) {}
}
