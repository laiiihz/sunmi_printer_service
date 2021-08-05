package tech.laihz.sunmi_printer_service

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.sunmi.peripheral.printer.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** SunmiPrinterServicePlugin */
class SunmiPrinterServicePlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private lateinit var printerManager: InnerPrinterManager
    private lateinit var context: Context
    private lateinit var activity: Activity
    private lateinit var sunmiService: SunmiPrinterService
    private lateinit var innerResultCallback: InnerResultCallback
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "sunmi_printer_service")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "init" -> {
                printerManager = InnerPrinterManager.getInstance()
                val innerPrinterCallback = object : InnerPrinterCallback() {
                    override fun onConnected(service: SunmiPrinterService?) {
                        Log.d("sunmi", "connected to service")
                        if (service != null) {
                            sunmiService = service
                        } else {
                            //TODO fail
                        }
                    }

                    override fun onDisconnected() {
                        //TODO 当服务异常断开后，会回调此⽅法，建议在此做重连策略
                        Log.w("sunmi", "disconnected to service")
                    }
                }
                innerResultCallback = object : InnerResultCallback() {
                    override fun onRunResult(p0: Boolean) {
                        Log.d("sunmi", "onRunResult:$p0")
                    }

                    override fun onReturnString(p0: String?) {
                        Log.d("sunmi", "onRunResult:$p0")
                    }

                    override fun onRaiseException(p0: Int, p1: String?) {
                        Log.w("sunmi", "onRaiseException:$p0:$p1")
                    }

                    override fun onPrintResult(p0: Int, p1: String?) {
                        Log.d("sunmi", "onPrintResult:$p0:$p1")
                    }

                }
                val initResult: Boolean =
                    printerManager.bindService(context, innerPrinterCallback)
                result.success(initResult)
            }
            "unbind" -> {
                val innerPrinterCallback = object : InnerPrinterCallback() {
                    override fun onConnected(service: SunmiPrinterService?) {
                        Log.d("sunmi", "connected to service")
                    }

                    override fun onDisconnected() {
                        Log.w("sunmi", "disconnected to service")
                    }
                }
                printerManager.unBindService(context, innerPrinterCallback)
                result.success(true)
            }
            "text" -> {
                val text = call.argument<String>("text")
                sunmiService.printText(text, innerResultCallback)
                result.success(null)
            }
            "setAlign" -> {
                val align = call.argument<Int>("align")
                sunmiService.setAlignment(align ?: 0, innerResultCallback)
                result.success(null)
            }
            "setFontSize" -> {
                val size = call.argument<Double>("size")
                val computedSize = (size ?: 0).toString().toFloat()
                sunmiService.setFontSize(computedSize, innerResultCallback)
                result.success(null)
            }
            "textWithFont" -> {
                val text = call.argument<String>("text")
                //TODO not support yet
                val typeface = call.argument<String>("typeface")
                val fontSize = call.argument<Double>("size")
                val computedSize = (fontSize ?: 0).toString().toFloat()
                sunmiService.printTextWithFont(text, typeface, computedSize, innerResultCallback)
                result.success(null)
            }
            "originText" -> {
                val text = call.argument<String>("text")
                sunmiService.printOriginalText(text, innerResultCallback)
                result.success(null)
            }
            "printColumnsText" -> {
                val text = call.argument<List<String>>("text")
                val width = call.argument<List<Int>>("width")
                val align = call.argument<List<Int>>("align")
                val computedText: Array<String> = text?.toTypedArray() ?: emptyArray()
                val computedWidth: IntArray = width?.toIntArray() ?: intArrayOf()
                val computedAlign: IntArray = align?.toIntArray() ?: intArrayOf()
                sunmiService.printColumnsText(
                    computedText,
                    computedWidth,
                    computedAlign,
                    innerResultCallback
                )
                result.success(null)
            }
            "printColumnsString" -> {
                val text = call.argument<List<String>>("text")
                val width = call.argument<List<Int>>("width")
                val align = call.argument<List<Int>>("align")
                val computedText: Array<String> = text?.toTypedArray() ?: emptyArray()
                val computedWidth: IntArray = width?.toIntArray() ?: intArrayOf()
                val computedAlign: IntArray = align?.toIntArray() ?: intArrayOf()
                sunmiService.printColumnsString(
                    computedText,
                    computedWidth,
                    computedAlign,
                    innerResultCallback
                )
                result.success(null)
            }
            "lineWrap" -> {
                val line: Int? = call.argument<Int>("line")
                sunmiService.lineWrap(line ?: 1, innerResultCallback)
                result.success(null)
            }
            "printBarCode" -> {
                val code: String? = call.argument<String>("code")
                val height: Int? = call.argument<Int>("height")
                val width: Int? = call.argument<Int>("width")
                val symbology: Int? = call.argument<Int>("symbology")
                val textPosition: Int? = call.argument<Int>("textPosition")
                sunmiService.printBarCode(
                    code,
                    height ?: 162,
                    width ?: 2,
                    symbology ?: 0,
                    textPosition ?: 0,
                    innerResultCallback
                )
                result.success(null)
            }
            "printQRCode" -> {
                val code: String? = call.argument<String>("code")
                val moduleSize: Int? = call.argument<Int>("moduleSize")
                val errorLevel: Int? = call.argument<Int>("errorLevel")
                sunmiService.printQRCode(
                    code,
                    moduleSize ?: 4,
                    errorLevel ?: 2,
                    innerResultCallback
                )
                result.success(null)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        TODO("Not yet implemented")
    }

    override fun onDetachedFromActivity() {
        TODO("Not yet implemented")
    }
}
