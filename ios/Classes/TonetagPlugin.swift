import Flutter
import UIKit

public class TonetagPlugin: NSObject, FlutterPlugin {
    let KEY = "b8fe72d954aa9bf7261e3c2f2b145b0befb61a54a8a7f1bb17c749cc92b2ada0"
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "tonetag", binaryMessenger: registrar.messenger())
        let instance = TonetagPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "initializeTonetag":
                initializeTonetag(
                    call: call,
                    result: result
                )
            case "startSendingData":
                startSendingData(
                    call: call,
                    result: result
                )
            case "stopSendingData":
                stopSendingData(
                    call: call,
                    result: result
                )
            case "startReceivingData":
                startReceivingData(
                    call: call,
                    result: result
                )
            case "stopReceivingData":
                stopReceivingData(
                    call: call,
                    result: result
                )
            default:
                break
        }
    }
    
    func initializeTonetag(call: FlutterMethodCall, result: @escaping FlutterResult) {}
    
    func startSendingData(call: FlutterMethodCall, result: @escaping FlutterResult) {}
    
    func stopSendingData(call: FlutterMethodCall, result: @escaping FlutterResult) {}
    
    func startReceivingData(call: FlutterMethodCall, result: @escaping FlutterResult) {}
    
    func stopReceivingData(call: FlutterMethodCall, result: @escaping FlutterResult) {}
}
