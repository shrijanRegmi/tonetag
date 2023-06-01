import UIKit
import Flutter
import ToneTag

let KEY = "b8fe72d954aa9bf7261e3c2f2b145b0befb61a54a8a7f1bb17c749cc92b2ada0"

let SONIC_30_BYTE = "sonic30Byte"
let ULTRASONIC_10_BYTE = "ultrasonic10Byte"
let IVR_14_Byte = "ivr14Byte"

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, TTToneTagManagerDelegate, TTOnToneTagRecorderDelegate, TTOnToneTagPlayerDelegate {
    var controller: FlutterViewController? = nil
    
    var mToneTagManager: ToneTagManager?
    var mSoundRecorder = TTSoundRecorder()
    var mSoundPlayer = TTSoundPlayer()
    
    func tt(onDataFound string: String!) {
        
    }
    
    func ttToneTagManagerError(_ error: Error!) {
        
    }

    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        controller = window?.rootViewController as? FlutterViewController
        let channel = FlutterMethodChannel(
            name: "tonetag",
            binaryMessenger: controller!.binaryMessenger
        )
      
        channel.setMethodCallHandler({ [self]
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
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
      })
      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
    func initializeTonetag(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (mToneTagManager == nil) {
            mToneTagManager = ToneTagManager()
            mToneTagManager?.toneTagManagerDelegate = self as TTToneTagManagerDelegate
        }
        
        if (mToneTagManager != nil) {
            mSoundRecorder = mToneTagManager?.getSoundRecorderInstance(withSubscriptionKey: KEY) as! TTSoundRecorder
            mSoundRecorder.ttRecorderDelegate = self as TTOnToneTagRecorderDelegate
            mSoundPlayer = mToneTagManager?.getSoundPlayerInstance(withSubscriptionKey: KEY) as! TTSoundPlayer
            mSoundPlayer.ttPlayerDelegate = self as TTOnToneTagPlayerDelegate
            
            result(nil)
        } else {
            result(
                FlutterError(
                    code: "initialization-failure",
                    message: "TonetagPlugin not initialized",
                    details: "TonetagPlugin not initialized properly. Try calling initializeTonetag() function before everything"
                )
            )
        }
    }
    
    func startSendingData(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(mToneTagManager == nil) {
            result(
                FlutterError(
                    code: "initialization-failure",
                    message: "TonetagPlugin not initialized",
                    details: "TonetagPlugin not initialized properly. Try calling initializeTonetag() function before everything"
                )
            )
            return
        }
        
        
        let args = call.arguments as! [String : Any]
        let data = args["data"] as! String
        let player = args["player"] as! String
        let channel = args["channel"] as? Int ?? 0
        let volume = args["volume"] as? Int ?? 50
        
        playTune(data: data, player: player, channel: channel, volume: volume)
    }
    
    func stopSendingData(call: FlutterMethodCall, result: @escaping FlutterResult) {
        stopTune()
        result(nil)
    }
    
    func startReceivingData(call: FlutterMethodCall, result: @escaping FlutterResult) {
        mSoundRecorder.ttStartRecording()
        result(nil)
    }
    
    func stopReceivingData(call: FlutterMethodCall, result: @escaping FlutterResult) {
        mSoundRecorder.ttStopRecording()
        result(nil)
    }
    
    func playTune(data: String, player: String, channel: Int, volume: Int) {
        var vol = volume;
        if(vol > 100) {
          vol = 100
        } else if (vol < 0) {
          vol = 0
        }
        
        var channelType = channel_A
        switch channel {
            case 0:
                channelType = channel_A
            case 1:
                channelType = channel_B
            case 2:
                channelType = channel_C
            default:
                channelType = channel_A
        }
        
        mSoundPlayer.setSystemVolume(CGFloat(vol))
        
        switch player {
            case SONIC_30_BYTE:
                mSoundPlayer.ttPlay30USString(data, forChannel: channelType)
            case ULTRASONIC_10_BYTE:
                mSoundPlayer.ttPlay30USString(data, forChannel: channelType)
            case IVR_14_Byte:
                mSoundPlayer.ttPlay30USString(data, forChannel: channelType)
            default:
                return()
        }
    }
    
    func stopTune() {
        mSoundPlayer.ttStop();
    }
    
    func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15

        controller.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
}
