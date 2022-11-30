package com.podamibenepal.smartparking

import android.view.KeyEvent
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import com.google.zxing.integration.android.IntentIntegrator


class MainActivity: FlutterActivity() {
    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        val intentIntegrator = IntentIntegrator(this@MainActivity)

        when (keyCode) {
            KeyEvent.KEYCODE_VOLUME_UP -> intentIntegrator.initiateScan()
            KeyEvent.KEYCODE_VOLUME_DOWN -> Toast.makeText(applicationContext, "Wrong Volume button Pressed", Toast.LENGTH_SHORT).show()
        }
        return true
    }
}
