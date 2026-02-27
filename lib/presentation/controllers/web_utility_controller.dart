import 'package:flutter/foundation.dart';

import '../../domain/entities/interop_entities.dart';
import '../../domain/repositories/web_utility_repository.dart';
import '../state/web_utility_state.dart';

class WebUtilityController extends ChangeNotifier {
  WebUtilityController({required WebUtilityRepository repository})
    : _repository = repository,
      _state = WebUtilityState.initial();

  final WebUtilityRepository _repository;
  WebUtilityState _state;

  WebUtilityState get state => _state;

  bool _initialized = false;
  bool _disposed = false;

  void initialize() {
    if (_initialized || _disposed) {
      return;
    }
    _initialized = true;

    _emit(
      _state.copyWith(
        support: _repository.loadSupportSnapshot(),
        isOnline: _repository.currentOnlineStatus,
        isSpeechListening: _repository.speechActive,
      ),
    );

    _repository.subscribeNetworkStatus(_onNetworkStatusChanged);
    _repository.subscribeSpeechRecognition(
      onResult: _onSpeechResult,
      onState: _onSpeechState,
    );

    _appendSystemLog('Loaded browser support snapshot.');
  }

  void refreshSupportSnapshot() {
    _emit(_state.copyWith(support: _repository.loadSupportSnapshot()));
    _appendSystemLog('Support snapshot refreshed.');
  }

  void selectSpeechLanguage(SpeechLanguage language) {
    if (_state.isSpeechListening || _state.speechLanguage == language) {
      return;
    }
    _emit(_state.copyWith(speechLanguage: language));
  }

  Future<void> copyClipboard(String text) async {
    final InteropActionResult result = await _repository.copyClipboard(text);
    if (_disposed) {
      return;
    }

    if (result.success) {
      final List<String> snippets = List<String>.from(
        _state.recentClipboardSnippets,
      );
      if (result.value.trim().isNotEmpty) {
        snippets.remove(result.value);
        snippets.insert(0, result.value);
      }
      if (snippets.length > 5) {
        snippets.removeLast();
      }

      _emit(
        _state.copyWith(
          clipboardOutput: result.value,
          recentClipboardSnippets: snippets,
        ),
      );
    }

    _appendActionLog('Clipboard', result);
  }

  Future<void> readClipboard() async {
    final InteropActionResult result = await _repository.readClipboard();
    if (_disposed) {
      return;
    }

    if (result.success) {
      _emit(_state.copyWith(clipboardOutput: result.value));
    }

    _appendActionLog('Clipboard', result);
  }

  Future<void> requestNotificationAccess() async {
    final InteropActionResult result = await _repository
        .requestNotificationAccess();
    if (_disposed) {
      return;
    }

    if (result.value.isNotEmpty) {
      _emit(_state.copyWith(notificationPermission: result.value));
    }

    _appendActionLog('Notification', result);
  }

  void sendNotification({required String title, required String body}) {
    final InteropActionResult result = _repository.sendNotification(
      title: title,
      body: body,
    );
    _appendActionLog('Notification', result);
  }

  void startSpeechRecognition() {
    final InteropActionResult result = _repository.startSpeech(
      locale: _state.speechLanguage.locale,
    );
    _appendActionLog('Speech', result);
  }

  void stopSpeechRecognition() {
    final InteropActionResult result = _repository.stopSpeech();
    _appendActionLog('Speech', result);
  }

  void clearSpeechTranscript() {
    _emit(
      _state.copyWith(
        liveSpeechText: 'Press Start Listening and speak.',
        finalSpeechText: '',
      ),
    );
    _appendSystemLog('Speech transcript cleared.');
  }

  void clearActivityLog() {
    _emit(_state.copyWith(activityLog: <ActivityEntry>[]));
  }

  void _onNetworkStatusChanged(bool isOnline) {
    if (_disposed) {
      return;
    }

    _emit(
      _state.copyWith(isOnline: isOnline, lastNetworkChange: DateTime.now()),
    );

    final String status = isOnline ? 'Online' : 'Offline';
    _appendSystemLog('Network changed: $status');
  }

  void _onSpeechResult(SpeechTranscriptChunk chunk) {
    if (_disposed || chunk.transcript.trim().isEmpty) {
      return;
    }

    final String updatedFinalSpeechText = chunk.isFinal
        ? (_state.finalSpeechText.isEmpty
              ? chunk.transcript
              : '${_state.finalSpeechText}\n${chunk.transcript}')
        : _state.finalSpeechText;

    _emit(
      _state.copyWith(
        liveSpeechText: chunk.transcript,
        finalSpeechText: updatedFinalSpeechText,
      ),
    );

    if (chunk.isFinal) {
      final String transcript = chunk.transcript.length > 70
          ? '${chunk.transcript.substring(0, 70)}...'
          : chunk.transcript;
      _pushLog('[Speech][FINAL] $transcript', true, chunk.timestamp);
    }
  }

  void _onSpeechState(SpeechStateUpdate stateUpdate) {
    if (_disposed) {
      return;
    }

    final bool isError = stateUpdate.status == 'error';
    final bool isListening = stateUpdate.status == 'listening';
    final String liveSpeechText =
        stateUpdate.status == 'stopped' && _state.liveSpeechText.trim().isEmpty
        ? 'Press Start Listening and speak.'
        : _state.liveSpeechText;

    _emit(
      _state.copyWith(
        isSpeechListening: isListening,
        liveSpeechText: liveSpeechText,
      ),
    );

    _pushLog(
      '[Speech][${stateUpdate.status.toUpperCase()}] ${stateUpdate.message}',
      !isError,
      stateUpdate.timestamp,
    );
  }

  void _appendActionLog(String area, InteropActionResult result) {
    final String status = result.success ? 'OK' : 'ERR';
    final String valuePart = result.value.isEmpty ? '' : ' | ${result.value}';
    _pushLog(
      '[$area][$status] ${result.message}$valuePart',
      result.success,
      result.timestamp,
    );
  }

  void _appendSystemLog(String message) {
    _pushLog('[System] $message', true, DateTime.now());
  }

  void _pushLog(String message, bool success, DateTime timestamp) {
    final List<ActivityEntry> updatedLog =
        List<ActivityEntry>.from(_state.activityLog)..insert(
          0,
          ActivityEntry(
            message: message,
            success: success,
            timestamp: timestamp,
          ),
        );

    if (updatedLog.length > 60) {
      updatedLog.removeLast();
    }

    _emit(_state.copyWith(activityLog: updatedLog));
  }

  void _emit(WebUtilityState nextState) {
    if (_disposed) {
      return;
    }

    _state = nextState;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _repository.unsubscribeSpeechRecognition();
    _repository.unsubscribeNetworkStatus();
    super.dispose();
  }
}
