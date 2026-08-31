import 'package:flutter/material.dart';

import 'jarvis/ether_jarvis_controller.dart';
import 'jarvis/ether_jarvis_voice.dart';

void main() {
  runApp(const EtherOS());
}

class EtherOS extends StatelessWidget {
  const EtherOS({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ETHER-OS',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF03050A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5FF),
          secondary: Color(0xFF7C4DFF),
        ),
      ),
      home: const EtherJarvisHome(),
    );
  }
}

class EtherJarvisHome extends StatefulWidget {
  const EtherJarvisHome({super.key});

  @override
  State<EtherJarvisHome> createState() => _EtherJarvisHomeState();
}

class _EtherJarvisHomeState extends State<EtherJarvisHome>
    with SingleTickerProviderStateMixin {
  final EtherJarvisController _jarvis = EtherJarvisController();
  late final EtherJarvisVoice _jarvisVoice;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final AnimationController _orbController;

  bool _isListening = false;
  bool _isThinking = false;

  final String _voiceState = 'READY';

  Color get _stateColor {
    switch (_voiceState) {
      case 'LISTENING':
        return const Color(0xFF00E5FF);
      case 'PROCESSING':
        return const Color(0xFF7C4DFF);
      case 'SPEAKING':
        return const Color(0xFF00FF9D);
      case 'ERROR':
      case 'UNAVAILABLE':
        return Colors.redAccent;
      default:
        return const Color(0xFF00E5FF);
    }
  }

  IconData get _stateIcon {
    switch (_voiceState) {
      case 'LISTENING':
        return Icons.mic_rounded;
      case 'PROCESSING':
        return Icons.psychology_rounded;
      case 'SPEAKING':
        return Icons.volume_up_rounded;
      case 'ERROR':
        return Icons.error_outline_rounded;
      case 'UNAVAILABLE':
        return Icons.cloud_off_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }

  String get _stateDescription {
    switch (_voiceState) {
      case 'LISTENING':
        return 'Listening for your command';
      case 'PROCESSING':
        return 'Analyzing and executing';
      case 'SPEAKING':
        return 'Delivering response';
      case 'ERROR':
        return 'Execution encountered an error';
      case 'UNAVAILABLE':
        return 'Voice service unavailable';
      default:
        return 'Awaiting your command';
    }
  }

  int _selectedIndex = 0;

  final List<Map<String, String>> _messages = [
    {
      'role': 'ether',
      'text': 'ETHER intelligence core online.\\n\\nAwaiting your command.',
    },
  ];

  final List<String> _sections = ['CORE', 'AI', 'BUSINESS', 'SYSTEM'];

  @override
  void initState() {
    super.initState();

    _jarvisVoice = EtherJarvisVoice(jarvis: _jarvis);

    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _orbController.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(child: _content()),
            _navigation(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF00E5FF)),
              boxShadow: const [
                BoxShadow(color: Color(0x3300E5FF), blurRadius: 18),
              ],
            ),
            child: const Icon(Icons.hub_rounded, color: Color(0xFF00E5FF)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ETHER',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
                Text(
                  'AUTONOMOUS INTELLIGENCE',
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.white38,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF00E5FF).withValues(alpha: .3),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.circle, size: 7, color: Color(0xFF00E5FF)),
                SizedBox(width: 6),
                Text(
                  'ONLINE',
                  style: TextStyle(
                    color: Color(0xFF00E5FF),
                    fontSize: 8,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _content() {
    switch (_selectedIndex) {
      case 1:
        return _aiPage();
      case 2:
        return _businessPage();
      case 3:
        return _systemPage();
      default:
        return _corePage();
    }
  }

  Widget _corePage() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
      children: [
        _coreHeader(),
        const SizedBox(height: 18),
        _orbSection(),
        const SizedBox(height: 18),
        _commandCard(),
        const SizedBox(height: 14),
        _statusGrid(),
      ],
    );
  }

  Widget _coreHeader() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF00E5FF).withValues(alpha: .35),
            ),
            color: const Color(0xFF00E5FF).withValues(alpha: .05),
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: Color(0xFF00E5FF),
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ETHER-OS',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'AUTONOMOUS INTELLIGENCE SYSTEM',
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.white38,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
        ),
        _statePill(),
      ],
    );
  }

  Widget _statePill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _stateColor.withValues(alpha: .35)),
        color: _stateColor.withValues(alpha: .07),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _stateColor,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            _voiceState,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: _stateColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _orbSection() {
    return Container(
      height: 285,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _stateColor.withValues(alpha: .16)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF08111A), const Color(0xFF03050A)],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _orbController,
            builder: (context, child) {
              final pulse = 0.82 + (_orbController.value * 0.18);

              return Transform.scale(
                scale: _isListening || _isThinking ? pulse : 0.9,
                child: child,
              );
            },
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _stateColor.withValues(alpha: .22),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _stateColor.withValues(alpha: .10),
                    blurRadius: 45,
                    spreadRadius: 12,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 116,
                  height: 116,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _stateColor.withValues(alpha: .5),
                      width: 2,
                    ),
                    color: _stateColor.withValues(alpha: .035),
                    boxShadow: [
                      BoxShadow(
                        color: _stateColor.withValues(alpha: .18),
                        blurRadius: 30,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Icon(_stateIcon, size: 42, color: _stateColor),
                ),
              ),
            ),
          ),
          Positioned(
            top: 18,
            left: 20,
            child: _orbLabel(Icons.memory_outlined, 'INTELLIGENCE', 'ONLINE'),
          ),
          Positioned(
            top: 18,
            right: 20,
            child: _orbLabel(Icons.shield_outlined, 'SAFETY', 'ACTIVE'),
          ),
          Positioned(
            bottom: 18,
            child: Column(
              children: [
                Text(
                  _voiceState,
                  style: TextStyle(
                    color: _stateColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _stateDescription,
                  style: const TextStyle(color: Colors.white38, fontSize: 9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _orbLabel(IconData icon, String title, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.white38),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 7,
                color: Colors.white30,
                letterSpacing: 1,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 8,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _commandCard() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFF080D14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: .07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.terminal_rounded,
                size: 17,
                color: Color(0xFF00E5FF),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'COMMAND CENTER',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.3,
                  ),
                ),
              ),
              Text(
                _isThinking ? 'PROCESSING' : 'READY',
                style: TextStyle(
                  fontSize: 8,
                  color: _isThinking ? const Color(0xFF7C4DFF) : Colors.white38,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _messages.isEmpty
                ? 'Awaiting your command.'
                : _messages.last['text'] ?? '',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white60,
              height: 1.45,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isThinking ? null : _toggleVoice,
                  icon: Icon(
                    _isListening ? Icons.stop_rounded : Icons.mic_none_rounded,
                    size: 17,
                  ),
                  label: Text(_isListening ? 'STOP' : 'VOICE'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _stateColor,
                    side: BorderSide(color: _stateColor.withValues(alpha: .35)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isThinking ? null : _send,
                  icon: const Icon(Icons.arrow_upward_rounded, size: 17),
                  label: const Text('COMMAND'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: const Color(0xFF00E5FF),
                    disabledForegroundColor: Colors.black38,
                    disabledBackgroundColor: const Color(
                      0xFF00E5FF,
                    ).withValues(alpha: .18),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusGrid() {
    return Row(
      children: [
        Expanded(
          child: _metric(
            'JARVIS',
            _jarvis.isInitialized ? 'ONLINE' : 'READY',
            Icons.psychology_outlined,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _metric(
            'VOICE',
            _isListening ? 'ACTIVE' : 'READY',
            Icons.graphic_eq_rounded,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(child: _metric('FEK', 'ACTIVE', Icons.account_tree_outlined)),
      ],
    );
  }

  Widget _metric(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF080D16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF00E5FF).withValues(alpha: 0.16),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: _stateColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _aiPage() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
            itemCount: _messages.length + (_isThinking ? 1 : 0),
            itemBuilder: (context, index) {
              if (_isThinking && index == _messages.length) {
                return _bubble(
                  'ether',
                  'Processing command...',
                  thinking: true,
                );
              }

              final message = _messages[index];

              return _bubble(message['role'] ?? 'ether', message['text'] ?? '');
            },
          ),
        ),
        _inputBar(),
      ],
    );
  }

  Widget _bubble(String role, String text, {bool thinking = false}) {
    final user = role == 'user';

    return Align(
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 350),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: user
              ? const Color(0xFF00E5FF).withValues(alpha: .08)
              : const Color(0xFF0A0E16),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: user
                ? const Color(0xFF00E5FF).withValues(alpha: .25)
                : Colors.white.withValues(alpha: .07),
          ),
        ),
        child: Column(
          crossAxisAlignment: user
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              user ? 'YOU' : 'ETHER',
              style: TextStyle(
                color: user ? const Color(0xFF00E5FF) : const Color(0xFF7C4DFF),
                fontSize: 8,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              text,
              style: TextStyle(
                color: thinking ? Colors.white30 : Colors.white70,
                height: 1.45,
                fontStyle: thinking ? FontStyle.italic : FontStyle.normal,
              ),
            ),
            if (!user && !thinking) ...[
              const SizedBox(height: 5),
              IconButton(
                tooltip: 'Speak',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                icon: const Icon(
                  Icons.volume_up_rounded,
                  size: 17,
                  color: Colors.white38,
                ),
                onPressed: () => _speak(text),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _inputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF03050A),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: .07)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                enabled: !_isThinking,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
                decoration: InputDecoration(
                  hintText: 'Command ETHER...',
                  filled: true,
                  fillColor: const Color(0xFF0A0E16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            IconButton(
              tooltip: 'Voice',
              onPressed: _isThinking ? null : _toggleVoice,
              icon: Icon(
                _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
              ),
              color: _isListening ? Colors.redAccent : const Color(0xFF00E5FF),
            ),
            IconButton(
              tooltip: 'Send',
              onPressed: _isThinking ? null : _send,
              icon: const Icon(Icons.arrow_upward_rounded),
              color: const Color(0xFF00E5FF),
            ),
          ],
        ),
      ),
    );
  }

  Widget _businessPage() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        _pageTitle(
          Icons.business_center_outlined,
          'BUSINESS COMMAND',
          'Autonomous business operations',
        ),
        const SizedBox(height: 18),
        _statusCard(
          Icons.account_tree_outlined,
          'BUSINESS FEK',
          'Observe → Decide → Plan → Execute → Measure → Learn',
          true,
        ),
        _statusCard(
          Icons.schedule_outlined,
          'AUTONOMY LOOP',
          'Business worker and scheduler available',
          true,
        ),
        _statusCard(
          Icons.verified_user_outlined,
          'FINANCIAL BOUNDARY',
          'Financial commitments require your approval',
          true,
        ),
        const SizedBox(height: 18),
        _sectionLabel('CONTROL CENTER'),
        const SizedBox(height: 10),
        _largeAction(Icons.play_arrow_rounded, 'RUN BUSINESS CHECK'),
        _largeAction(Icons.pending_actions_rounded, 'APPROVAL QUEUE'),
        _largeAction(Icons.analytics_outlined, 'BUSINESS STATE'),
      ],
    );
  }

  Widget _systemPage() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        _pageTitle(
          Icons.settings_outlined,
          'SYSTEM',
          'ETHER infrastructure and integrations',
        ),
        const SizedBox(height: 18),
        _statusCard(
          Icons.psychology_outlined,
          'MODEL',
          'Model provider abstraction ready',
          true,
        ),
        _statusCard(
          Icons.memory_outlined,
          'PERSISTENT MEMORY',
          'Memory subsystem available',
          true,
        ),
        _statusCard(
          Icons.extension_outlined,
          'SKILLS',
          'Skill execution framework active',
          true,
        ),
        _statusCard(
          Icons.link_rounded,
          'INTEGRATIONS',
          'External tools will connect here',
          false,
        ),
        _statusCard(
          Icons.forum_outlined,
          'COMMUNICATION',
          'Telegram / Slack / other channels',
          false,
        ),
        _statusCard(
          Icons.cloud_outlined,
          'DEPLOYMENT',
          'Laptop / Mac Mini / cloud server',
          false,
        ),
      ],
    );
  }

  Widget _pageTitle(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF00E5FF).withValues(alpha: .2),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: const Color(0xFF00E5FF)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.white54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusCard(
    IconData icon,
    String title,
    String subtitle,
    bool active,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF090D15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: .07)),
      ),
      child: Row(
        children: [
          Icon(icon, color: active ? const Color(0xFF00E5FF) : Colors.white30),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: .8,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0x73FFFFFF),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            active ? Icons.check_circle : Icons.circle_outlined,
            size: 17,
            color: active ? const Color(0xFF00E5FF) : Colors.white24,
          ),
        ],
      ),
    );
  }

  Widget _largeAction(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFF091019),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFF00E5FF).withValues(alpha: .14),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00E5FF)),
          const SizedBox(width: 14),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: .8,
            ),
          ),
          const Spacer(),
          const Icon(Icons.chevron_right_rounded, color: Colors.white30),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 9,
        color: Colors.white38,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.6,
      ),
    );
  }

  Widget _navigation() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF090D15),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: .08)),
      ),
      child: Row(
        children: List.generate(_sections.length, (index) {
          final selected = _selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF00E5FF).withValues(alpha: .08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      [
                        Icons.hub_outlined,
                        Icons.auto_awesome,
                        Icons.business_center_outlined,
                        Icons.settings_outlined,
                      ][index],
                      size: 19,
                      color: selected
                          ? const Color(0xFF00E5FF)
                          : Colors.white38,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _sections[index],
                      style: TextStyle(
                        fontSize: 7,
                        letterSpacing: .8,
                        color: selected
                            ? const Color(0xFF00E5FF)
                            : Colors.white38,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> _send() async {
    final message = _controller.text.trim();

    if (message.isEmpty || _isThinking) {
      return;
    }

    _controller.clear();

    setState(() {
      _messages.add({'role': 'user', 'text': message});
      _isThinking = true;
    });

    await _scrollBottom();

    try {
      final response = await _jarvis.execute(message);

      if (!mounted) {
        return;
      }

      setState(() {
        _messages.add({'role': 'ether', 'text': response});
        _isThinking = false;
      });

      await _scrollBottom();
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _messages.add({
          'role': 'ether',
          'text': 'ETHER encountered an error while processing the command.',
        });
        _isThinking = false;
      });

      await _scrollBottom();
    }
  }

  Future<void> _toggleVoice() async {
    if (_isListening) {
      await _jarvisVoice.stop();

      if (!mounted) return;

      setState(() {
        _isListening = false;
        _isThinking = false;
      });

      return;
    }

    if (_isThinking) {
      return;
    }

    if (!mounted) return;

    setState(() {
      _isListening = true;
    });

    try {
      await _jarvisVoice.listenOnce(
        onUserText: (text) {
          if (!mounted) return;

          setState(() {
            _controller.text = text;
            _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: _controller.text.length),
            );
          });
        },
        onEtherResponse: (response) {
          if (!mounted) return;

          setState(() {
            final existingUserMessage = _controller.text.trim();

            if (existingUserMessage.isNotEmpty) {
              _messages.add({'role': 'user', 'text': existingUserMessage});
            }

            _controller.clear();

            _messages.add({'role': 'ether', 'text': response});

            _isThinking = false;
          });

          _scrollBottom();
        },
        onStatus: (status) {
          if (!mounted) return;

          setState(() {
            switch (status) {
              case 'LISTENING':
                _isListening = true;
                _isThinking = false;
                break;

              case 'PROCESSING':
                _isListening = false;
                _isThinking = true;
                break;

              case 'SPEAKING':
                _isListening = false;
                _isThinking = false;
                break;

              case 'READY':
              case 'ERROR':
              case 'UNAVAILABLE':
                _isListening = false;
                _isThinking = false;
                break;
            }
          });
        },
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isListening = false;
        _isThinking = false;
        _messages.add({
          'role': 'ether',
          'text': 'ETHER voice encountered an error: $error',
        });
      });

      await _scrollBottom();
    } finally {
      if (mounted) {
        setState(() {
          _isListening = false;
        });
      }
    }
  }

  Future<void> _speak(String text) async {
    await _jarvisVoice.speak(text);
  }

  Future<void> _scrollBottom() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));

    if (!_scrollController.hasClients) return;

    await _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }
}
