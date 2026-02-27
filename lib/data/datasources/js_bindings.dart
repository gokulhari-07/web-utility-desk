@JS()
library;

import 'dart:js_interop';

@JS('getApiSupportJson')
external String getApiSupportJson();

@JS('copyTextToClipboard')
external JSPromise<JSString> copyTextToClipboard(JSString text);

@JS('readClipboardText')
external JSPromise<JSString> readClipboardText();

@JS('requestNotificationPermission')
external JSPromise<JSString> requestNotificationPermission();

@JS('sendBrowserNotification')
external String sendBrowserNotification(JSString title, JSString body);

@JS('registerSpeechRecognitionCallbacks')
external void registerSpeechRecognitionCallbacks(
  JSExportedDartFunction onResultCallback,
  JSExportedDartFunction onStateCallback,
);

@JS('unregisterSpeechRecognitionCallbacks')
external void unregisterSpeechRecognitionCallbacks();

@JS('startSpeechRecognition')
external String startSpeechRecognition(JSString locale);

@JS('stopSpeechRecognition')
external String stopSpeechRecognition();

@JS('isSpeechRecognitionActive')
external bool isSpeechRecognitionActive();

@JS('getOnlineStatus')
external bool getOnlineStatus();

@JS('registerNetworkListener')
external void registerNetworkListener(JSExportedDartFunction callback);

@JS('unregisterNetworkListener')
external void unregisterNetworkListener();
