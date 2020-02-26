package com.sumitgohil.admob.flutter_admob_plugin

import android.content.Context
import android.view.View
import com.google.android.gms.ads.AdListener
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.AdSize
import com.google.android.gms.ads.AdView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.platform.PlatformView

class AdmobBanner(context: Context, messenger: BinaryMessenger, id: Int, args: HashMap<*, *>?) : PlatformView, MethodCallHandler {
  private val channel: MethodChannel = MethodChannel(messenger, "admob/banner_$id")
  private val adView: AdView = AdView(context)

  init {
    channel.setMethodCallHandler(this)

    adView.adSize = getSize(args?.get("adSize") as HashMap<*, *>)
    adView.adUnitId = args?.get("adUnitId") as String?

    val adRequest = AdRequest.Builder().build()
    adView.loadAd(adRequest)
  }

  private fun getSize(size: HashMap<*, *>) : AdSize {
    val width = size["width"] as Int
    val height = size["height"] as Int
    val name = size["name"] as String

    return when(name) {
      "BANNER" -> AdSize.BANNER
      "LARGE_BANNER" -> AdSize.LARGE_BANNER
      "MEDIUM_RECTANGLE" -> AdSize.MEDIUM_RECTANGLE
      "FULL_BANNER" -> AdSize.FULL_BANNER
      "LEADERBOARD" -> AdSize.LEADERBOARD
      "SMART_BANNER" -> AdSize.SMART_BANNER
      else -> AdSize(width, height)
    }
  }

  override fun getView(): View {
    return adView
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when(call.method) {
      "setListener" -> adView.adListener = createAdListener(channel)
      "dispose" -> dispose()
      else -> result.notImplemented()
    }
  }

  fun createAdListener(channel: MethodChannel) : AdListener {
    return object: AdListener() {
      override fun onAdLoaded() = channel.invokeMethod("loaded", null)
      override fun onAdFailedToLoad(errorCode: Int) = channel.invokeMethod("failedToLoad", hashMapOf("errorCode" to errorCode))
      override fun onAdClicked() = channel.invokeMethod("clicked", null)
      override fun onAdImpression() = channel.invokeMethod("impression", null)
      override fun onAdOpened() = channel.invokeMethod("opened", null)
      override fun onAdLeftApplication() = channel.invokeMethod("leftApplication", null)
      override fun onAdClosed() = channel.invokeMethod("closed", null)
    }
  }

  override fun dispose() {
    adView.visibility = View.GONE
    adView.destroy()
    channel.setMethodCallHandler(null)
  }
}