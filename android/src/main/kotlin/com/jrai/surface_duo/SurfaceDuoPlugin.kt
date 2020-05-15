package com.jrai.surface_duo

import android.app.Activity
import android.content.Context.SENSOR_SERVICE
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import com.microsoft.device.display.DisplayMask
import android.hardware.Sensor
import android.hardware.SensorManager
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class SurfaceDuoPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private val HINGE_ANGLE_SENSOR_NAME = "Hinge Angle"
  private var mSensorsSetup : Boolean = false
  private var mSensorManager: SensorManager? = null
  private var mHingeAngleSensor: Sensor? = null
  private var mSensorListener: SensorEventListener? = null
  private var mCurrentHingeAngle: Float = 0.0f

  private var activity: Activity? = null;

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.flutterEngine.dartExecutor, "surface_duo")
    channel.setMethodCallHandler(this);
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "surface_duo")
      channel.setMethodCallHandler(SurfaceDuoPlugin())
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    val isDual = isDualScreenDevice()
    if(isDual == null || !isDual) {
      result.success(false)
    } else {
      try {
        if (call.method == "isDualScreenDevice") {
          if (isDual) {
            result.success(true)
          } else {
            result.success(false)
          }
        } else if (call.method == "isAppSpanned") {
          val isAppSpanned = isAppSpanned();
          if (isAppSpanned != null && isAppSpanned) {
            result.success(true)
          } else {
            result.success(false)
          }
        } else if (call.method == "getHingeAngle") {
          if (!mSensorsSetup) {
            setupSensors()
          }
          result.success(mCurrentHingeAngle)
        } else {
          result.notImplemented()
        }
      } catch(e: Exception){
        result.success(false)
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity;
  }

  override fun onDetachedFromActivity() {
    activity = null;
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity;
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null;
  }

  fun isDualScreenDevice(): Boolean? {
    if (activity == null) return null;

    val feature = "com.microsoft.device.display.displaymask"
    val pm = activity!!.packageManager
    return pm.hasSystemFeature(feature)
  }

  fun isAppSpanned(): Boolean? {
    if (activity == null) return null;

    val displayMask = DisplayMask.fromResourcesRectApproximation(activity)
    val boundings = displayMask.boundingRects
    val first = boundings[0]
    val rootView = activity!!.window.decorView.rootView
    val drawingRect = android.graphics.Rect()
    rootView.getDrawingRect(drawingRect)

    return first.intersect(drawingRect)
  }

  //todo what to do when SensorManager is null?
  fun setupSensors() {
    mSensorManager = activity!!.getSystemService(SENSOR_SERVICE) as SensorManager?
    val sensorList: List<Sensor> = mSensorManager!!.getSensorList(Sensor.TYPE_ALL)

    for (sensor in sensorList) {
      if (sensor.name.contains(HINGE_ANGLE_SENSOR_NAME)) {
        mHingeAngleSensor = sensor
        break
      }
    }

    mSensorListener = object : SensorEventListener {
      override fun onSensorChanged(event: SensorEvent) {
        if (event.sensor === mHingeAngleSensor) {
          mCurrentHingeAngle = event.values[0]
        }
      }

      override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        //TODO – Add support later
      }
    }

    mSensorManager!!.registerListener(
            mSensorListener,
            mHingeAngleSensor,
            SensorManager.SENSOR_DELAY_NORMAL)

    mSensorsSetup = true
  }
}
