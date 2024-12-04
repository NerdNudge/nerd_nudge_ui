package com.neurospark.nerd_nudge

import android.os.Bundle
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import android.view.WindowManager
import android.view.WindowInsets

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Set up the SplashScreen API for Android 12+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Using the system SplashScreen API
            splashScreen.setOnExitAnimationListener { view ->
                // Customize exit animation if needed, otherwise the default system behavior will be used
                view.remove()
            }
        }

        // Ensure that the system UI (like the status bar) doesn't overlap with the splash screen
        window.setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN)
    }
}