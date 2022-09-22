package com.example.stepper

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "flutter.stepper/stepper"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "getStepperContent") {
                    result.success(getStepperContent())
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getStepperContent() :Map<String,String>{
        return mapOf(
            "Select campaign settings" to "For each ad campaign you create you can create how much you are willing to spend on clicks and conversions, which network and geographical locations you want your ads to show on and more.",
            "Create an ad group" to "For each ad campaign you create you can create how much you are willing to spend on clicks and conversions, which network and geographical locations you want your ads to show on and more.",
            "Create an ad" to "For each ad campaign you create you can create how much you are willing to spend on clicks and conversions, which network and geographical locations you want your ads to show on and more.",
        )
    }
}
