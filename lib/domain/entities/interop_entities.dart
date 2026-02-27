import 'dart:convert';

class ApiSupportSnapshot {
  const ApiSupportSnapshot({
    required this.clipboard,
    required this.notifications,
    required this.speechRecognition,
    required this.network,
  });

  factory ApiSupportSnapshot.fromMap(Map<String, dynamic> map) {
    return ApiSupportSnapshot(
      clipboard: map['clipboard'] == true,
      notifications: map['notifications'] == true,
      speechRecognition: map['speechRecognition'] == true,
      network: map['network'] == true,
    );
  }

  const ApiSupportSnapshot.empty()
    : clipboard = false,
      notifications = false,
      speechRecognition = false,
      network = false;

  final bool clipboard;
  final bool notifications;
  final bool speechRecognition;
  final bool network;

  List<(String, bool)> get entries => <(String, bool)>[
    ('Clipboard', clipboard),
    ('Notifications', notifications),
    ('Speech', speechRecognition),
    ('Network', network),
  ];
}

class InteropActionResult {
  const InteropActionResult({
    required this.success,
    required this.message,
    required this.timestamp,
    this.value = '',
  });

  factory InteropActionResult.fromJsonString(String rawJson) {
    try {
      final Object? decoded = jsonDecode(rawJson);
      if (decoded is! Map<String, dynamic>) {
        return InteropActionResult.failure('Invalid response payload.');
      }

      return InteropActionResult(
        success: decoded['success'] == true,
        message: (decoded['message'] ?? '').toString(),
        value: (decoded['value'] ?? '').toString(),
        timestamp:
            DateTime.tryParse((decoded['timestamp'] ?? '').toString()) ??
            DateTime.now(),
      );
    } catch (_) {
      return InteropActionResult.failure('Failed to parse JS response.');
    }
  }

  factory InteropActionResult.failure(String message) {
    return InteropActionResult(
      success: false,
      message: message,
      timestamp: DateTime.now(),
    );
  }

  final bool success;
  final String message;
  final String value;
  final DateTime timestamp;
}

class SpeechTranscriptChunk {
  const SpeechTranscriptChunk({
    required this.transcript,
    required this.isFinal,
    required this.timestamp,
  });

  factory SpeechTranscriptChunk.fromJsonString(String rawJson) {
    try {
      final Object? decoded = jsonDecode(rawJson);
      if (decoded is! Map<String, dynamic>) {
        return SpeechTranscriptChunk.empty();
      }

      return SpeechTranscriptChunk(
        transcript: (decoded['transcript'] ?? '').toString(),
        isFinal: decoded['isFinal'] == true,
        timestamp:
            DateTime.tryParse((decoded['timestamp'] ?? '').toString()) ??
            DateTime.now(),
      );
    } catch (_) {
      return SpeechTranscriptChunk.empty();
    }
  }

  factory SpeechTranscriptChunk.empty() {
    return SpeechTranscriptChunk(
      transcript: '',
      isFinal: false,
      timestamp: DateTime.now(),
    );
  }

  final String transcript;
  final bool isFinal;
  final DateTime timestamp;
}

class SpeechStateUpdate {
  const SpeechStateUpdate({
    required this.status,
    required this.message,
    required this.timestamp,
  });

  factory SpeechStateUpdate.fromJsonString(String rawJson) {
    try {
      final Object? decoded = jsonDecode(rawJson);
      if (decoded is! Map<String, dynamic>) {
        return SpeechStateUpdate.invalid();
      }

      return SpeechStateUpdate(
        status: (decoded['status'] ?? 'unknown').toString(),
        message: (decoded['message'] ?? '').toString(),
        timestamp:
            DateTime.tryParse((decoded['timestamp'] ?? '').toString()) ??
            DateTime.now(),
      );
    } catch (_) {
      return SpeechStateUpdate.invalid();
    }
  }

  factory SpeechStateUpdate.invalid() {
    return SpeechStateUpdate(
      status: 'unknown',
      message: 'Invalid speech state payload.',
      timestamp: DateTime.now(),
    );
  }

  final String status;
  final String message;
  final DateTime timestamp;
}

enum SpeechLanguage {
  english('English', 'en-US'),
  hindi('Hindi', 'hi-IN'),
  malayalam('Malayalam', 'ml-IN');

  const SpeechLanguage(this.label, this.locale);

  final String label;
  final String locale;
}
