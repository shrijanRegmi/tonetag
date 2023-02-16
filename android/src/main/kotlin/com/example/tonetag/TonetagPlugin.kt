package com.example.tonetag

import android.content.Context
import android.media.AudioManager
import android.media.ToneGenerator
import android.os.Handler
import android.os.Looper
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LifecycleRegistry
import com.tonetag.tone.SoundPlayer
import com.tonetag.tone.SoundRecorder
import com.tonetag.tone.TTUtils
import com.tonetag.tone.ToneTagManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** TonetagPlugin */
class TonetagPlugin: FlutterPlugin, MethodCallHandler, LifecycleOwner {
  companion object {
    const val METHOD_CHANNEL = "tonetag"
    const val EVENT_CHANNEL_IS_SENDING_DATA = "tonetag_event_channel/isSendingData"
    const val EVENT_CHANNEL_IS_RECEIVING_DATA = "tonetag_event_channel/isReceivingData"
    const val EVENT_CHANNEL_ON_DATA_RECEIVED= "tonetag_event_channel/onDataReceived"

    const val SONIC_30_BYTE = "sonic30Byte"
    const val ULTRASONIC_10_BYTE = "ultrasonic10Byte"
    const val IVR_14_Byte = "ivr14Byte"
  }

  private lateinit var lifecycleRegistry: LifecycleRegistry

  private lateinit var context: Context;
  private lateinit var methodChannel : MethodChannel
  private lateinit var ecIsSendingData : EventChannel
  private lateinit var ecIsReceivingData : EventChannel
  private lateinit var ecOnDataReceived : EventChannel

  private var esIsSending: EventSink? = null
  private var esIsReceiving: EventSink? = null
  private var esOnDataReceived: EventSink? = null

  private val toneGenerator: ToneGenerator = ToneGenerator(AudioManager.STREAM_ALARM, 50)
  private var toneTagManager: ToneTagManager? = null
  private var soundRecorder: SoundRecorder? = null
  private var soundPlayer: SoundPlayer? = null
  private var isSendingData: Boolean = false;
  private var isReceivingData: Boolean = false;
  private val uiThreadHandler: Handler = Handler(Looper.getMainLooper())
  private val isReceivingHandler: Handler = Handler(Looper.getMainLooper())
  private val isSendingHandler: Handler = Handler(Looper.getMainLooper())
  private var playCount = 0;

  private val isReceivingRunner: Runnable = object: Runnable {
    override fun run() {
      val isRecordingOn = soundRecorder?.isRecordingOn == true;
      if(isReceivingData != isRecordingOn) {
        isReceivingData = isRecordingOn;
        esIsReceiving?.success(soundRecorder?.isRecordingOn == true);
      }
      isReceivingHandler.postDelayed(this, 200);
    }
  }

  private val isSendingRunner: Runnable = object: Runnable {
    override fun run() {
      val isPlayerOn = soundPlayer?.isPlaying == true;
      if(isSendingData != isPlayerOn) {
        isSendingData = isPlayerOn;
        esIsSending?.success(soundPlayer?.isPlaying == true);
      }
      isSendingHandler.postDelayed(this, 200);
    }
  }

  private val key: String = "577b2fa0000c2daa7153f49b122903eca92dedddbec56ce7db5aba3284ecff81";

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    lifecycleRegistry = LifecycleRegistry(this)
    lifecycleRegistry.currentState = Lifecycle.State.CREATED
    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, METHOD_CHANNEL)
    ecOnDataReceived = EventChannel(flutterPluginBinding.binaryMessenger, EVENT_CHANNEL_ON_DATA_RECEIVED)
    ecIsSendingData = EventChannel(flutterPluginBinding.binaryMessenger, EVENT_CHANNEL_IS_SENDING_DATA)
    ecIsReceivingData = EventChannel(flutterPluginBinding.binaryMessenger, EVENT_CHANNEL_IS_RECEIVING_DATA)

    methodChannel.setMethodCallHandler(this)
    onEventCall();

    context = flutterPluginBinding.applicationContext;
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when(call.method) {
      "initializeTonetag" -> initializeTonetag(call, result)
      "startSendingData" -> startSendingData(call, result)
      "stopSendingData" -> stopSendingData(call, result)
      "startReceivingData" -> startReceivingData(call, result)
      "stopReceivingData" -> stopReceivingData(call, result)
      else -> result.notImplemented()
    }
  }

  private fun onEventCall() {
    ecIsSendingData.setStreamHandler(object: EventChannel.StreamHandler {
      override fun onListen(arguments: Any?, events: EventSink?) {
        esIsSending = events
        esIsSending?.success(soundPlayer?.isPlaying == true)
        isSendingHandler.post(isSendingRunner);
      }

      override fun onCancel(arguments: Any?) {
        esIsSending = null
        isSendingHandler.removeCallbacks(isSendingRunner)
      }
    })

    ecIsReceivingData.setStreamHandler(object: EventChannel.StreamHandler {
      override fun onListen(arguments: Any?, events: EventSink?) {
        esIsReceiving = events;
        esIsReceiving?.success(soundRecorder?.isRecordingOn == true);
        isReceivingHandler.post(isReceivingRunner);
      }

      override fun onCancel(arguments: Any?) {
        esIsReceiving = null;
        isReceivingHandler.removeCallbacks(isReceivingRunner);
      }
    })

    ecOnDataReceived.setStreamHandler(object: EventChannel.StreamHandler {
      override fun onListen(arguments: Any?, events: EventSink?) {
        esOnDataReceived = events;
        esOnDataReceived?.success(hashMapOf<String, String>());
        onDataReceived();
      }

      override fun onCancel(arguments: Any?) {
        esOnDataReceived = null;
      }
    })
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
    ecOnDataReceived.setStreamHandler(null)
    isReceivingHandler.removeCallbacks(isReceivingRunner);
  }

  private fun initializeTonetag(call: MethodCall, result: Result) {
    try {
      toneTagManager = ToneTagManager(context, key);
      soundRecorder = toneTagManager?.soundRecorderInstance;
      soundPlayer = toneTagManager?.soundPlayerInstance;

      result.success(null);
    } catch (e: Exception) {
      result.error("initializeTonetagFailedException", e.message, e.message);
    }
  }

  private fun startSendingData(call: MethodCall, result: Result) {
    if(soundPlayer == null) {
      result.error(
          "initialization-failure",
          "TonetagPlugin not initialized",
          "TonetagPlugin not initialized. Try calling initializeTonetag() function before listening to onDataReceived"
      )
      return
    }

    if(soundPlayer?.isPlaying == false) {
      val data = call.argument<String>("data")
      val player = call.argument<String>("player");
      val volume = call.argument<Int>("volume") ?: 50;

      playTune(data, player, volume);
      result.success(null);

      soundPlayer?.setTTOnPlaybackFinishedListener(object: SoundPlayer.TTOnPlaybackFinishedListener {
        override fun TTOnPlaybackFinished(p0: Array<out String>?, p1: Int, p2: IntArray?) {
          try {
            playTune(data, player, volume);
            toneGenerator.startTone(ToneGenerator.TONE_DTMF_9, 60)
          } catch (e: java.lang.RuntimeException) {
            result.error("null", e.message, e.toString());
          }
        }

        override fun TTOnPlaybackError(p0: Int, p1: String?) {
          result.error("null", "$p0 and $p1", null);
        }
      })
    }
  }

  private fun stopSendingData(call: MethodCall, result: Result) {
    stopTune();
    result.success(null);
  }

  private fun startReceivingData(call: MethodCall, result: Result) {
    if(soundRecorder?.isRecordingOn == false) {
      soundRecorder?.TTStartRecording(SoundRecorder._RECORDER_MODE_ALL)
      result.success(null);
    }
  }

  private fun stopReceivingData(call: MethodCall, result: Result) {
    if(soundRecorder?.isRecordingOn == true) {
      soundRecorder!!.TTStopRecording()
      result.success(null)
    }
  }

  private fun onDataReceived() {
    if(esOnDataReceived == null) return

    if(soundRecorder == null) {
      esOnDataReceived?.error(
        "initialization-failure",
        "TonetagPlugin not initialized",
        "TonetagPlugin not initialized. Try calling initializeTonetag() function before listening to onDataReceived"
      )
      return
    }

    soundRecorder?.setTTOnDataFoundListener(object: SoundRecorder.TTOnDataFoundListener{
      override fun TTOnDataFound(p0: String?, p1: TTUtils.TTRecorderDataType?) {
        try {
          uiThreadHandler.post {
            esOnDataReceived?.success(hashMapOf("data" to "$p0"));
          }
        } catch (e: java.lang.RuntimeException) {
          uiThreadHandler.post {
            esOnDataReceived?.endOfStream();
          }
        }
      }

      override fun TTOnRecorderError(p0: Int, p1: String?) {
        esOnDataReceived?.success(null);
      }
    });
  }

  override fun getLifecycle(): Lifecycle {
    return lifecycleRegistry;
  }

  private fun playTune(data: String?, player: String?, volume: Int) {
    var vol = volume;
    if(vol > 100) {
      vol = 100
    } else if (vol < 0) {
      vol = 0
    }

    soundPlayer?.deviceVolume = vol;

    when(player) {
      SONIC_30_BYTE -> soundPlayer?.TTPlay30SString(data, vol)
      ULTRASONIC_10_BYTE -> soundPlayer?.TTPlay10USString(data, 0, vol)
      IVR_14_Byte -> soundPlayer?.TTPlay14IVRString(data, vol)
      else -> soundPlayer?.TTPlay30SString(data, vol)
    }
  }

  private fun stopTune() {
    if (soundPlayer?.isPlaying == true) {
      soundPlayer?.TTStopPlaying();
    }
    playCount = 0
  }
}
