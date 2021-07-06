package com.example.flutterdesktopapp;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.interpretervisualizer";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if(call.method.equals("simpleInterpreter")){
                                   String code =  call.arguments();
                                   simpleInterpreter(code);
                            }else{
                                result.notImplemented();
                            }
                        }
                );
    }

    private void simpleInterpreter(String code){
        System.out.println(code);
        // Write the code here
    }
}


