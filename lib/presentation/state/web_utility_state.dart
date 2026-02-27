import '../../domain/entities/interop_entities.dart';

class ActivityEntry {
  const ActivityEntry({
    required this.message,
    required this.success,
    required this.timestamp,
  });

  final String message;
  final bool success;
  final DateTime timestamp;
}

class WebUtilityState {
  const WebUtilityState({
    required this.support,
    required this.isOnline,
    required this.isSpeechListening,
    required this.speechLanguage,
    required this.lastNetworkChange,
    required this.clipboardOutput,
    required this.notificationPermission,
    required this.liveSpeechText,
    required this.finalSpeechText,
    required this.recentClipboardSnippets,
    required this.activityLog,
  });

  factory WebUtilityState.initial() {
    return const WebUtilityState(
      support: ApiSupportSnapshot.empty(),
      isOnline: true,
      isSpeechListening: false,
      speechLanguage: SpeechLanguage.english,
      lastNetworkChange: null,
      clipboardOutput: 'Clipboard value will appear here.',
      notificationPermission: 'unknown',
      liveSpeechText: 'Press Start Listening and speak.',
      finalSpeechText: '',
      recentClipboardSnippets: <String>[],
      activityLog: <ActivityEntry>[],
    );
  }

  final ApiSupportSnapshot support;
  final bool isOnline;
  final bool isSpeechListening;
  final SpeechLanguage speechLanguage;
  final DateTime? lastNetworkChange;
  final String clipboardOutput;
  final String notificationPermission;
  final String liveSpeechText;
  final String finalSpeechText;
  final List<String> recentClipboardSnippets;
  final List<ActivityEntry> activityLog;

  WebUtilityState copyWith({
    ApiSupportSnapshot? support,
    bool? isOnline,
    bool? isSpeechListening,
    SpeechLanguage? speechLanguage,
    DateTime? lastNetworkChange,
    String? clipboardOutput,
    String? notificationPermission,
    String? liveSpeechText,
    String? finalSpeechText,
    List<String>? recentClipboardSnippets,
    List<ActivityEntry>? activityLog,
  }) {
    return WebUtilityState(
      support: support ?? this.support,
      isOnline: isOnline ?? this.isOnline,
      isSpeechListening: isSpeechListening ?? this.isSpeechListening,
      speechLanguage: speechLanguage ?? this.speechLanguage,
      lastNetworkChange: lastNetworkChange ?? this.lastNetworkChange,
      clipboardOutput: clipboardOutput ?? this.clipboardOutput,
      notificationPermission:
          notificationPermission ?? this.notificationPermission,
      liveSpeechText: liveSpeechText ?? this.liveSpeechText,
      finalSpeechText: finalSpeechText ?? this.finalSpeechText,
      recentClipboardSnippets: recentClipboardSnippets == null
          ? this.recentClipboardSnippets
          : List<String>.unmodifiable(recentClipboardSnippets),
      activityLog: activityLog == null
          ? this.activityLog
          : List<ActivityEntry>.unmodifiable(activityLog),
    );
  }
}
