import '../entities/interop_entities.dart';

abstract class WebUtilityRepository {
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
