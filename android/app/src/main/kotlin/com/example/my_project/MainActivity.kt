package com.mycompany.appvendedores

import android.content.ContentValues
import android.content.Intent
import android.net.Uri
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.OutputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.mycompany.appvendedores/media_store"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "saveFile" -> {
                    val fileBytes = call.argument<ByteArray>("fileBytes")
                    val fileName = call.argument<String>("fileName")
                    val mimeType = call.argument<String>("mimeType")

                    if (fileBytes != null && fileName != null && mimeType != null) {
                        try {
                            val filePath = saveFileInDownloads(fileBytes, fileName, mimeType)
                            if (filePath != null) {
                                result.success(filePath)
                                openFile(Uri.parse(filePath), mimeType)  // Abrir el archivo después de guardarlo
                            } else {
                                result.error("ERROR", "Error al guardar el archivo", null)
                            }
                        } catch (e: Exception) {
                            result.error("EXCEPTION", "Excepción: ${e.message}", null)
                        }
                    } else {
                        result.error("INVALID_ARGUMENTS", "Argumentos inválidos", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun saveFileInDownloads(fileBytes: ByteArray, fileName: String, mimeType: String): String? {
        val contentValues = ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
            put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
            put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)  // 📂 Guarda en "Descargas"
        }

        val resolver = applicationContext.contentResolver
        val uri: Uri? = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, contentValues)

        if (uri != null) {
            try {
                resolver.openOutputStream(uri)?.use { it.write(fileBytes) }
                return uri.toString()
            } catch (e: Exception) {
                Log.e("MainActivity", "Error al guardar el archivo: ${e.message}")
                return null
            }
        }
        return null
    }

    private fun openFile(uri: Uri, mimeType: String) {
        try {
            val intent = Intent(Intent.ACTION_VIEW).apply {
                setDataAndType(uri, mimeType)
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }
            startActivity(intent)
        } catch (e: Exception) {
            Log.e("MainActivity", "Error al abrir el archivo: ${e.message}")
        }
    }
}
