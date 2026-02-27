import 'dart:convert';
import 'dart:js_interop';

import '../../domain/entities/interop_entities.dart';
import 'js_bindings.dart';

abstract class WebUtilityJsDataSource {
  ApiSupportSnapshot loadSupportSnapshot();

  bool get currentOnlineStatus;
  bool get speechActive;

  Future<InteropActionResult> copyClipboard(String text);
  Future<InteropActionResult> readClipboard();
  Future<InteropActionResult> requestNotificationAccess();

  InteropActionResult sendNotification({
    required String title,
    required String body,
  });

  InteropActionResult startSpeech({required String locale});
  InteropActionResult stopSpeech();

  void subscribeSpeechRecognition({
    required void Function(SpeechTranscriptChunk chunk) onResult,
    required void Function(SpeechStateUpdate state) onState,
  });

  void unsubscribeSpeechRecognition();

  void subscribeNetworkStatus(void Function(bool isOnline) onChanged);
  void unsubscribeNetworkStatus();
}

class WebUtilityJsDataSourceImpl implements WebUtilityJsDataSource {
  JSExportedDartFunction? _networkCallback;
  JSExportedDartFunction? _speechResultCallback;
  JSExportedDartFunction? _speechStateCallback;

  @override
  ApiSupportSnapshot loadSupportSnapshot() {
    final Object? decoded = jsonDecode(getApiSupportJson());
    if (decoded is! Map<String, dynamic>) {
      return const ApiSupportSnapshot.empty();
    }
    return ApiSupportSnapshot.fromMap(decoded);
  }

  @override
  bool get currentOnlineStatus => getOnlineStatus();

  @override
  bool get speechActive => isSpeechRecognitionActive();

  @override
  Future<InteropActionResult> copyClipboard(String text) async {
    final JSString jsResult = await copyTextToClipboard(text.toJS).toDart;
    return InteropActionResult.fromJsonString(jsResult.toDart);
  }

  @override
  Future<InteropActionResult> readClipboard() async {
    final JSString jsResult = await readClipboardText().toDart;
    return InteropActionResult.fromJsonString(jsResult.toDart);
  }

  @override
  Future<InteropActionResult> requestNotificationAccess() async {
    final JSString jsResult = await requestNotificationPermission().toDart;
    return InteropActionResult.fromJsonString(jsResult.toDart);
  }

  @override
  InteropActionResult sendNotification({
    required String title,
    required String body,
  }) {
    final String response = sendBrowserNotification(title.toJS, body.toJS);
    return InteropActionResult.fromJsonString(response);
  }

  @override
  InteropActionResult startSpeech({required String locale}) {
    final String response = startSpeechRecognition(locale.toJS);
    return InteropActionResult.fromJsonString(response);
  }

  @override
  InteropActionResult stopSpeech() {
    final String response = stopSpeechRecognition();
    return InteropActionResult.fromJsonString(response);
  }

  @override
  void subscribeSpeechRecognition({
    required void Function(SpeechTranscriptChunk chunk) onResult,
    required void Function(SpeechStateUpdate state) onState,
  }) {
    unsubscribeSpeechRecognition();

    _speechResultCallback = ((JSString payload) {
      onResult(SpeechTranscriptChunk.fromJsonString(payload.toDart));
    }).toJS;

    _speechStateCallback = ((JSString payload) {
      onState(SpeechStateUpdate.fromJsonString(payload.toDart));
    }).toJS;

    registerSpeechRecognitionCallbacks(
      _speechResultCallback!,
      _speechStateCallback!,
    );
  }

  @override
  void unsubscribeSpeechRecognition() {
    unregisterSpeechRecognitionCallbacks();
    _speechResultCallback = null;
    _speechStateCallback = null;
  }

  @override
  void subscribeNetworkStatus(void Function(bool isOnline) onChanged) {
    unsubscribeNetworkStatus();

    _networkCallback = ((JSBoolean isOnline) {
      onChanged(isOnline.toDart);
    }).toJS;

    registerNetworkListener(_networkCallback!);
  }

  @override
  void unsubscribeNetworkStatus() {
    unregisterNetworkListener();
    _networkCallback = null;
  }
}
