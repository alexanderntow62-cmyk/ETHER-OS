import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ai/ether_ai.dart';
import 'ai/local_ether_ai.dart';
import 'ai/ether_voice.dart';

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
        scaffoldBackgroundColor: const Color(0xFF05070D),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5FF),
          secondary: Color(0xFF7C4DFF),
        ),
      ),
      home: const EtherHome(),
    );
  }
}

class EtherHome extends StatefulWidget {
  const EtherHome({super.key});

  @override
  State<EtherHome> createState() => _EtherHomeState();
}

class _EtherHomeState extends State<EtherHome> {
  int selectedIndex = 0;
  final EtherAI _etherAI = LocalEtherAI();
  final EtherVoice _voice = EtherVoice();
  bool _voiceReady = false;
  bool _isListening = false;
  final TextEditingController _aiController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final List<Map<String, String>> _chatMessages = [
    {'role': 'ether', 'text': 'Ether AI Core is connected and ready.'},
  ];
  bool _isThinking = false;

  final List<String> sections = ['CORE', 'AI', 'BUSINESS', 'SYSTEM'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(child: _content()),
            _bottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF00E5FF), width: 1.5),
            ),
            child: const Icon(
              Icons.hub_outlined,
              color: Color(0xFF00E5FF),
              size: 26,
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
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'INTELLIGENT OPERATING SYSTEM',
                  style: TextStyle(
                    fontSize: 9,
                    letterSpacing: 1.4,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF00E5FF).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF00E5FF).withValues(alpha: 0.35),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.circle, size: 8, color: Color(0xFF00E5FF)),
                SizedBox(width: 6),
                Text(
                  'ONLINE',
                  style: TextStyle(
                    fontSize: 9,
                    letterSpacing: 1.2,
                    color: Color(0xFF00E5FF),
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
    switch (selectedIndex) {
      case 1:
        return _aiPanel();
      case 2:
        return _businessPanel();
      case 3:
        return _systemPanel();
      default:
        return _corePanel();
    }
  }

  Widget _corePanel() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      children: [
        _heroCard(),
        const SizedBox(height: 16),
        _sectionTitle('SYSTEM OVERVIEW'),
        const SizedBox(height: 10),
        _infoCard(
          Icons.memory,
          'ETHER CORE',
          'Core intelligence engine ready.',
        ),
        _infoCard(Icons.auto_awesome, 'AI STATUS', 'AI subsystem initialized.'),
        _infoCard(
          Icons.business_center,
          'BUSINESS ENGINE',
          'Business automation layer ready.',
        ),
      ],
    );
  }

  Widget _heroCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF00E5FF).withValues(alpha: 0.25),
        ),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00E5FF).withValues(alpha: 0.12),
            const Color(0xFF7C4DFF).withValues(alpha: 0.08),
          ],
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.hub_outlined, color: Color(0xFF00E5FF), size: 38),
          SizedBox(height: 16),
          Text(
            'WELCOME TO ETHER',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'An intelligent operating system designed to connect AI, business automation, and system intelligence.',
            style: TextStyle(color: Colors.white60, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _aiPanel() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _chatScrollController,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            itemCount: _chatMessages.length + (_isThinking ? 1 : 0),
            itemBuilder: (context, index) {
              if (_isThinking && index == _chatMessages.length) {
                return _chatBubble(
                  role: 'ether',
                  text: 'ETHER is thinking...',
                  thinking: true,
                );
              }

              final message = _chatMessages[index];

              return _chatBubble(
                role: message['role'] ?? 'ether',
                text: message['text'] ?? '',
              );
            },
          ),
        ),
        _chatInput(),
      ],
    );
  }

  Widget _chatBubble({
    required String role,
    required String text,
    bool thinking = false,
  }) {
    final isUser = role == 'user';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUser
              ? const Color(0xFF00E5FF).withValues(alpha: 0.10)
              : const Color(0xFF0B0F18),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isUser
                ? const Color(0xFF00E5FF).withValues(alpha: 0.30)
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              isUser ? 'YOU' : 'ETHER',
              style: TextStyle(
                color: isUser
                    ? const Color(0xFF00E5FF)
                    : const Color(0xFF7C4DFF),
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              text,
              style: TextStyle(
                color: thinking ? Colors.white38 : Colors.white70,
                height: 1.5,
                fontStyle: thinking ? FontStyle.italic : FontStyle.normal,
              ),
            ),
            if (!thinking) ...[
              const SizedBox(height: 8),
              Align(
                alignment: isUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: IconButton(
                  tooltip: 'Copy',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  icon: const Icon(
                    Icons.copy_rounded,
                    size: 18,
                    color: Colors.white54,
                  ),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: text));

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copied to clipboard'),
                        duration: Duration(milliseconds: 900),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _chatInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF05070D),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _aiController,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                enabled: !_isThinking,
                decoration: InputDecoration(
                  hintText: 'Talk to Ether AI...',
                  filled: true,
                  fillColor: const Color(0xFF0B0F18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 13,
                  ),
                ),
                onSubmitted: (_) => _sendToEtherAI(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _isThinking ? null : _sendToEtherAI,
              icon: const Icon(Icons.send_rounded),
              color: const Color(0xFF00E5FF),
              iconSize: 28,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendToEtherAI() async {
    final message = _aiController.text.trim();

    if (message.isEmpty || _isThinking) {
      return;
    }

    _aiController.clear();

    setState(() {
      _chatMessages.add({'role': 'user', 'text': message});
      _isThinking = true;
    });

    await _scrollChatToBottom();

    try {
      final response = await _etherAI.respond(message);

      if (!mounted) {
        return;
      }

      setState(() {
        _chatMessages.add({'role': 'ether', 'text': response});
        _isThinking = false;
      });

      await _scrollChatToBottom();
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _chatMessages.add({
          'role': 'ether',
          'text': 'I encountered an error while processing that request.',
        });
        _isThinking = false;
      });

      await _scrollChatToBottom();
    }
  }

  Future<void> _scrollChatToBottom() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));

    if (!_chatScrollController.hasClients) {
      return;
    }

    await _chatScrollController.animateTo(
      _chatScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  Widget _businessPanel() {
    return _simplePanel(
      Icons.business_center_outlined,
      'BUSINESS',
      'Manage autonomous business operations from ETHER-OS.',
      'BUSINESS ENGINE READY',
    );
  }

  Widget _systemPanel() {
    return _simplePanel(
      Icons.settings_outlined,
      'SYSTEM',
      'System controls, security, storage, and connected services.',
      'SYSTEM ONLINE',
    );
  }

  Widget _simplePanel(
    IconData icon,
    String title,
    String description,
    String status,
  ) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF00E5FF).withValues(alpha: 0.25),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: const Color(0xFF00E5FF), size: 42),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: const TextStyle(color: Colors.white60, height: 1.5),
              ),
              const SizedBox(height: 22),
              Text(
                status,
                style: const TextStyle(
                  color: Color(0xFF00E5FF),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 11,
        letterSpacing: 1.6,
        color: Colors.white54,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _infoCard(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00E5FF)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.white54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavigation() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0F18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: List.generate(sections.length, (index) {
          final selected = selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF00E5FF).withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      [
                        Icons.dashboard_outlined,
                        Icons.auto_awesome,
                        Icons.business_center_outlined,
                        Icons.settings_outlined,
                      ][index],
                      size: 20,
                      color: selected
                          ? const Color(0xFF00E5FF)
                          : Colors.white54,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sections[index],
                      style: TextStyle(
                        fontSize: 8,
                        letterSpacing: 0.8,
                        color: selected
                            ? const Color(0xFF00E5FF)
                            : Colors.white54,
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
}
