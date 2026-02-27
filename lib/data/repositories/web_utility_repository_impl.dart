import '../../domain/entities/interop_entities.dart';
import '../../domain/repositories/web_utility_repository.dart';
import '../datasources/web_utility_js_datasource.dart';

class WebUtilityRepositoryImpl implements WebUtilityRepository {
  WebUtilityRepositoryImpl({required WebUtilityJsDataSource dataSource})
    : _dataSource = dataSource;

  final WebUtilityJsDataSource _dataSource;

  @override
  ApiSupportSnapshot loadSupportSnapshot() => _dataSource.loadSupportSnapshot();

  @override
  bool get currentOnlineStatus => _dataSource.currentOnlineStatus;

  @override
  bool get speechActive => _dataSource.speechActive;

  @override
  Future<InteropActionResult> copyClipboard(String text) {
    return _dataSource.copyClipboard(text);
  }

  @override
  Future<InteropActionResult> readClipboard() {
    return _dataSource.readClipboard();
  }

  @override
  Future<InteropActionResult> requestNotificationAccess() {
    return _dataSource.requestNotificationAccess();
  }

  @override
  InteropActionResult sendNotification({
    required String title,
    required String body,
  }) {
    return _dataSource.sendNotification(title: title, body: body);
  }

  @override
  InteropActionResult startSpeech({required String locale}) {
    return _dataSource.startSpeech(locale: locale);
  }

  @override
  InteropActionResult stopSpeech() => _dataSource.stopSpeech();

  @override
  void subscribeSpeechRecognition({
    required void Function(SpeechTranscriptChunk chunk) onResult,
    required void Function(SpeechStateUpdate state) onState,
  }) {
    _dataSource.subscribeSpeechRecognition(
      onResult: onResult,
      onState: onState,
    );
  }

  @override
  void unsubscribeSpeechRecognition() {
    _dataSource.unsubscribeSpeechRecognition();
  }

  @override
  void subscribeNetworkStatus(void Function(bool isOnline) onChanged) {
    _dataSource.subscribeNetworkStatus(onChanged);
  }

  @override
  void unsubscribeNetworkStatus() {
    _dataSource.unsubscribeNetworkStatus();
  }
}
