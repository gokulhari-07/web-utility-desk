import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/interop_entities.dart';
import '../../domain/repositories/web_utility_repository.dart';
import '../controllers/web_utility_controller.dart';
import '../state/web_utility_state.dart';
import '../widgets/ui_components.dart';

class WebUtilityPage extends StatefulWidget {
  const WebUtilityPage({super.key, required this.repository});

  final WebUtilityRepository repository;

  @override
  State<WebUtilityPage> createState() => _WebUtilityPageState();
}

class _WebUtilityPageState extends State<WebUtilityPage> {
  late final WebUtilityController _controller;

  final TextEditingController _clipboardInputController = TextEditingController(
    text: 'Project standup at 5:30 PM',
  );
  final TextEditingController _notificationTitleController =
      TextEditingController(text: 'Reminder');
  final TextEditingController _notificationBodyController =
      TextEditingController(text: 'Take a quick break and hydrate.');

  @override
  void initState() {
    super.initState();
    _controller = WebUtilityController(repository: widget.repository);
    _controller.initialize();
  }

  @override
  void dispose() {
    _clipboardInputController.dispose();
    _notificationTitleController.dispose();
    _notificationBodyController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final WebUtilityState state = _controller.state;
        return Scaffold(
          backgroundColor: const Color(0xFFF3ECE2),
          body: Stack(
            children: <Widget>[
              Positioned(
                top: -160,
                right: -120,
                child: Container(
                  width: 340,
                  height: 340,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: <Color>[Color(0x66C98A4A), Color(0x00C98A4A)],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -200,
                left: -140,
                child: Container(
                  width: 380,
                  height: 380,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: <Color>[Color(0x55427B78), Color(0x00427B78)],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1160),
                          child: LayoutBuilder(
                            builder:
                                (
                                  BuildContext context,
                                  BoxConstraints contentConstraints,
                                ) {
                                  const double spacing = 18;
                                  final bool multiColumn =
                                      contentConstraints.maxWidth >= 760;
                                  final int columns = multiColumn ? 2 : 1;
                                  final double contentWidth =
                                      contentConstraints.maxWidth;
                                  final double cardWidth =
                                      (contentWidth -
                                          (spacing * (columns - 1))) /
                                      columns;
                                  final double activityWidth = multiColumn
                                      ? contentWidth
                                      : cardWidth;

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      _buildHero(state),
                                      const SizedBox(height: 18),
                                      Wrap(
                                        spacing: spacing,
                                        runSpacing: spacing,
                                        children: <Widget>[
                                          SizedBox(
                                            width: cardWidth,
                                            child: _buildClipboardCard(state),
                                          ),
                                          SizedBox(
                                            width: cardWidth,
                                            child: _buildNotificationCard(
                                              state,
                                            ),
                                          ),
                                          SizedBox(
                                            width: cardWidth,
                                            child: _buildNetworkCard(state),
                                          ),
                                          SizedBox(
                                            width: cardWidth,
                                            child: _buildSpeechCard(state),
                                          ),
                                          SizedBox(
                                            width: activityWidth,
                                            child: _buildActivityCard(state),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHero(WebUtilityState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[
            Color(0xFF132B3A),
            Color(0xFF1E4650),
            Color(0xFF2F5D5A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x2D192129),
            blurRadius: 26,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -70,
            right: -30,
            child: Container(
              width: 170,
              height: 170,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x18FFFFFF),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Web Utility Desk',
                      style: GoogleFonts.sora(
                        color: const Color(0xFFF7F1E6),
                        fontSize: 38,
                        fontWeight: FontWeight.w700,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Practical browser tools in one focused workspace.',
                      style: TextStyle(
                        color: Color(0xFFD6E3DE),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: state.support.entries
                          .map(
                            (entry) =>
                                SupportChip(label: entry.$1, enabled: entry.$2),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 220),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    StatusPill(
                      label: 'Network',
                      value: state.isOnline ? 'Online' : 'Offline',
                      dotColor: state.isOnline
                          ? const Color(0xFF39C8A5)
                          : const Color(0xFFE76E5A),
                    ),
                    const SizedBox(height: 8),
                    StatusPill(
                      label: 'Speech',
                      value: state.isSpeechListening ? 'Listening' : 'Idle',
                      dotColor: state.isSpeechListening
                          ? const Color(0xFF39C8A5)
                          : const Color(0xFFE9BF72),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClipboardCard(WebUtilityState state) {
    return FeatureCard(
      title: 'Smart Clipboard',
      subtitle: 'Copy and read clipboard text.',
      icon: Icons.content_copy_rounded,
      accent: const Color(0xFF2B8A78),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTextField(
            controller: _clipboardInputController,
            label: 'Text to copy',
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              ActionButton(
                label: 'Copy',
                onPressed: () {
                  _controller.copyClipboard(_clipboardInputController.text);
                },
              ),
              ActionButton(
                label: 'Read Clipboard',
                onPressed: _controller.readClipboard,
              ),
            ],
          ),
          const SizedBox(height: 10),
          InlineOutput(text: state.clipboardOutput),
          if (state.recentClipboardSnippets.isNotEmpty) ...<Widget>[
            const SizedBox(height: 10),
            const Text(
              'Recent snippets',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: state.recentClipboardSnippets
                  .map((value) => TinyTag(text: value))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationCard(WebUtilityState state) {
    return FeatureCard(
      title: 'Quick Notify',
      subtitle: 'Permission + browser notification.',
      icon: Icons.notifications_active_rounded,
      accent: const Color(0xFFB24C3F),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Permission: ${state.notificationPermission}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _notificationTitleController,
            label: 'Notification title',
          ),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _notificationBodyController,
            label: 'Notification body',
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              ActionButton(
                label: 'Request Permission',
                onPressed: _controller.requestNotificationAccess,
              ),
              ActionButton(
                label: 'Send',
                onPressed: () {
                  _controller.sendNotification(
                    title: _notificationTitleController.text,
                    body: _notificationBodyController.text,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkCard(WebUtilityState state) {
    final String statusText = state.isOnline ? 'Online' : 'Offline';
    final Color statusColor = state.isOnline
        ? const Color(0xFF2B8A78)
        : const Color(0xFFB24C3F);
    final String changedText = state.lastNetworkChange == null
        ? 'Listening for online/offline events.'
        : 'Last changed: ${_formatTime(state.lastNetworkChange!)}';

    return FeatureCard(
      title: 'Connection Watch',
      subtitle: 'Live network status from JS callbacks.',
      icon: Icons.radar_rounded,
      accent: const Color(0xFF4A6FA5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.circle, color: statusColor, size: 12),
              const SizedBox(width: 8),
              Text(
                statusText,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(changedText),
          const SizedBox(height: 12),
          ActionButton(
            label: 'Refresh Support Snapshot',
            onPressed: _controller.refreshSupportSnapshot,
          ),
        ],
      ),
    );
  }

  Widget _buildSpeechCard(WebUtilityState state) {
    final bool supported = state.support.speechRecognition;
    final bool canSwitchLanguage = supported && !state.isSpeechListening;
    final Color statusColor = state.isSpeechListening
        ? const Color(0xFF2B8A78)
        : const Color(0xFF8B5A3C);
    final String statusLabel = state.isSpeechListening ? 'Listening' : 'Idle';

    return FeatureCard(
      title: 'Voice Transcriber',
      subtitle: 'Speak and convert voice to text live.',
      icon: Icons.graphic_eq_rounded,
      accent: const Color(0xFF8B5A3C),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.mic, size: 16, color: statusColor),
              const SizedBox(width: 8),
              Text(
                statusLabel,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
              const Spacer(),
              if (!supported)
                const Text(
                  'Not supported',
                  style: TextStyle(
                    color: Color(0xFF8A2D28),
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: SpeechLanguage.values
                .map(
                  (language) => ChoiceChip(
                    label: Text(language.label),
                    selected: state.speechLanguage == language,
                    onSelected: canSwitchLanguage
                        ? (selected) {
                            if (!selected) {
                              return;
                            }
                            _controller.selectSpeechLanguage(language);
                          }
                        : null,
                    selectedColor: const Color(0xFF214D45),
                    labelStyle: TextStyle(
                      color: state.speechLanguage == language
                          ? Colors.white
                          : const Color(0xFF2A2926),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              ActionButton(
                label: 'Start Listening',
                onPressed: supported && !state.isSpeechListening
                    ? _controller.startSpeechRecognition
                    : null,
              ),
              ActionButton(
                label: 'Stop',
                onPressed: supported && state.isSpeechListening
                    ? _controller.stopSpeechRecognition
                    : null,
              ),
              ActionButton(
                label: 'Clear Text',
                onPressed: _controller.clearSpeechTranscript,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Live transcript',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          InlineOutput(text: state.liveSpeechText),
          const SizedBox(height: 10),
          const Text(
            'Final transcript',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          InlineOutput(
            text: state.finalSpeechText.isEmpty
                ? 'Finalized speech text will appear here.'
                : state.finalSpeechText,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(WebUtilityState state) {
    return FeatureCard(
      title: 'Activity Log',
      subtitle: 'Recent actions and outcomes.',
      icon: Icons.timeline_rounded,
      accent: const Color(0xFF233144),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ActionButton(
                label: 'Clear Log',
                onPressed: _controller.clearActivityLog,
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (state.activityLog.isEmpty)
            const InlineOutput(text: 'No actions yet. Trigger any card above.')
          else
            ...state.activityLog.take(10).map(_buildLogTile),
        ],
      ),
    );
  }

  Widget _buildLogTile(ActivityEntry entry) {
    final Color tone = entry.success
        ? const Color(0xFFE7F4EE)
        : const Color(0xFFFCE9E4);
    final Color textTone = entry.success
        ? const Color(0xFF1F5F4C)
        : const Color(0xFF842F2C);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: tone,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: entry.success
              ? const Color(0xFFBEDDCE)
              : const Color(0xFFF0C4BA),
        ),
      ),
      child: Text(
        '${_formatTime(entry.timestamp)}  ${entry.message}',
        style: TextStyle(color: textTone, fontSize: 13),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF5D5A53)),
        filled: true,
        fillColor: const Color(0xFFFFFBF5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD8CCBB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF255768), width: 1.4),
        ),
      ),
    );
  }

  String _formatTime(DateTime value) {
    final String h = value.hour.toString().padLeft(2, '0');
    final String m = value.minute.toString().padLeft(2, '0');
    final String s = value.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}
