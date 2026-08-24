import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'agent/ether_agent.dart';
import 'ai/ether_voice.dart';
import 'business/business_control_center.dart';

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
  @override
  void initState() {
    super.initState();

    // Start with a safe local control center so the UI can build immediately.
    _businessControlCenter = BusinessControlCenter();

    // Replace it with the secure-storage initialized version when ready.
    _initializeBusinessControlCenter();
  }

  Future<void> _initializeBusinessControlCenter() async {
    try {
      final center = await BusinessControlCenter.fromSecureStorage();

      if (!mounted) {
        return;
      }

      setState(() {
        _businessControlCenter = center;
      });
    } catch (error) {
      debugPrint('Business Control Center initialization failed: $error');
    }
  }

  int selectedIndex = 0;
  final EtherAgent _etherAgent = EtherAgent();
  final EtherVoice _voice = EtherVoice();
  late BusinessControlCenter _businessControlCenter;
  final TextEditingController _businessGoalController = TextEditingController();
  bool _businessRunning = false;
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
    final pendingApprovals = _businessControlCenter.approvalQueue.pendingCount;
    final workerRunning = _businessControlCenter.worker.isRunning;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        _coreHeroCard(),
        const SizedBox(height: 18),

        _sectionTitle('CORE INTELLIGENCE'),
        const SizedBox(height: 10),

        _coreStatusCard(
          Icons.memory_rounded,
          'ETHER CORE',
          'Core intelligence engine',
          'OPERATIONAL',
        ),

        _coreStatusCard(
          Icons.auto_awesome_rounded,
          'AI ENGINE',
          'AI reasoning and conversation',
          'READY',
        ),

        _coreStatusCard(
          Icons.psychology_rounded,
          'AGENT',
          'Task planning and execution',
          'READY',
        ),

        _coreStatusCard(
          Icons.business_center_rounded,
          'BUSINESS ENGINE',
          'Autonomous business operations',
          workerRunning ? 'RUNNING' : 'READY',
        ),

        const SizedBox(height: 14),
        _sectionTitle('SYSTEM ACTIVITY'),
        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: _coreMetricCard(Icons.bolt_rounded, 'CORE', 'ONLINE'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _coreMetricCard(
                Icons.pending_actions_rounded,
                'APPROVALS',
                '$pendingApprovals',
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: _coreMetricCard(
                Icons.work_history_rounded,
                'WORKER',
                workerRunning ? 'ACTIVE' : 'IDLE',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _coreMetricCard(
                Icons.security_rounded,
                'SAFETY',
                'ACTIVE',
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),
        _sectionTitle('QUICK ACTIONS'),
        const SizedBox(height: 10),

        _coreActionCard(
          Icons.chat_bubble_outline_rounded,
          'TALK TO ETHER',
          'Open the AI Core and communicate with ETHER.',
          const Color(0xFF00E5FF),
          () {
            setState(() {
              selectedIndex = 1;
            });
          },
        ),

        _coreActionCard(
          Icons.business_center_outlined,
          'BUSINESS CONTROL',
          'Launch business intelligence and automation.',
          const Color(0xFF7C4DFF),
          () {
            setState(() {
              selectedIndex = 2;
            });
          },
        ),

        _coreActionCard(
          Icons.settings_outlined,
          'SYSTEM CONTROL',
          'View system controls and connected services.',
          const Color(0xFF00E5FF),
          () {
            setState(() {
              selectedIndex = 3;
            });
          },
        ),

        const SizedBox(height: 18),

        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFF0B0F18),
            border: Border.all(
              color: const Color(0xFFFFC107).withValues(alpha: 0.22),
            ),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.shield_outlined, color: Color(0xFFFFC107), size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ETHER SAFETY BOUNDARY',
                      style: TextStyle(
                        color: Color(0xFFFFC107),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      'ETHER can prepare and execute non-financial work autonomously. Financial actions require explicit user approval.',
                      style: TextStyle(
                        color: Colors.white60,
                        height: 1.5,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _coreHeroCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFF00E5FF).withValues(alpha: 0.28),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF00E5FF).withValues(alpha: 0.13),
            const Color(0xFF7C4DFF).withValues(alpha: 0.10),
            const Color(0xFF05070D),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.08),
                  border: Border.all(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.45),
                  ),
                ),
                child: const Icon(
                  Icons.hub_rounded,
                  color: Color(0xFF00E5FF),
                  size: 30,
                ),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ETHER CORE',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.8,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'INTELLIGENT OPERATING SYSTEM',
                      style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 1.3,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.08),
                  border: Border.all(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 7, color: Color(0xFF00E5FF)),
                    SizedBox(width: 5),
                    Text(
                      'ONLINE',
                      style: TextStyle(
                        fontSize: 8,
                        color: Color(0xFF00E5FF),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            'SYSTEM OPERATIONAL',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'ETHER is connected to the AI, agent, and business intelligence subsystems.',
            style: TextStyle(color: Colors.white60, height: 1.5, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _coreStatusCard(
    IconData icon,
    String title,
    String description,
    String status,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0F18),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: const Color(0xFF00E5FF).withValues(alpha: 0.07),
            ),
            child: Icon(icon, color: const Color(0xFF00E5FF), size: 23),
          ),
          const SizedBox(width: 13),
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
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(fontSize: 11, color: Colors.white54),
                ),
              ],
            ),
          ),
          Text(
            status,
            style: const TextStyle(
              color: Color(0xFF00E5FF),
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _coreMetricCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0F18),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF00E5FF), size: 21),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _coreActionCard(
    IconData icon,
    String title,
    String description,
    Color accent,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0B0F18),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: accent.withValues(alpha: 0.22)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: accent.withValues(alpha: 0.08),
              ),
              child: Icon(icon, color: accent, size: 24),
            ),
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
                    description,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: accent.withValues(alpha: 0.7),
              size: 15,
            ),
          ],
        ),
      ),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isUser)
                      IconButton(
                        tooltip: 'Speak',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                        icon: const Icon(
                          Icons.volume_up_rounded,
                          size: 18,
                          color: Colors.white54,
                        ),
                        onPressed: () => _speakEther(text),
                      ),
                    IconButton(
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
                  ],
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
            const SizedBox(width: 2),
            IconButton(
              tooltip: _isListening ? 'Stop listening' : 'Voice input',
              onPressed: _isThinking ? null : _toggleListening,
              icon: Icon(
                _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
              ),
              color: _isListening
                  ? const Color(0xFFFF5252)
                  : const Color(0xFF00E5FF),
              iconSize: 26,
            ),
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

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _voice.stopListening();

      if (!mounted) return;

      setState(() {
        _isListening = false;
      });

      return;
    }

    final ready = await _voice.initialize(
      onStatus: (status) {
        if (!mounted) return;

        if (status == 'notListening' || status == 'done') {
          setState(() {
            _isListening = false;
          });
        }
      },
      onError: (error) {
        if (!mounted) return;

        setState(() {
          _isListening = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Voice error: $error')));
      },
    );

    if (!ready) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone is not available.')),
      );

      return;
    }

    if (!mounted) return;

    setState(() {
      _isListening = true;
    });

    await _voice.startListening(
      onResult: (text, finalResult) {
        if (!mounted) return;

        setState(() {
          _aiController.text = text;
          _aiController.selection = TextSelection.fromPosition(
            TextPosition(offset: _aiController.text.length),
          );
        });

        if (finalResult) {
          setState(() {
            _isListening = false;
          });
        }
      },
    );
  }

  Future<void> _speakEther(String text) async {
    await _voice.speak(text);
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
      final response = await _etherAgent.run(message);

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
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      children: [
        _sectionTitle('BUSINESS CONTROL CENTER'),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF00E5FF).withValues(alpha: 0.25),
            ),
            color: const Color(0xFF0B0F18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.business_center_outlined,
                    color: Color(0xFF00E5FF),
                    size: 28,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'BUSINESS OPERATOR',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _businessGoalController,
                enabled: !_businessRunning,
                minLines: 2,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter a business goal...',
                  filled: true,
                  fillColor: const Color(0xFF05070D),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _businessRunning
                      ? null
                      : _runBusinessControlCenter,
                  icon: _businessRunning
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.play_arrow_rounded),
                  label: Text(
                    _businessRunning
                        ? 'BUSINESS CHECK RUNNING...'
                        : 'RUN BUSINESS CHECK',
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _infoCard(
          Icons.speed,
          'WORKER STATUS',
          _businessControlCenter.worker.isRunning
              ? 'AUTONOMOUS WORKER RUNNING'
              : 'WORKER IDLE',
        ),

        _infoCard(
          Icons.storefront_outlined,
          'REGISTERED BUSINESSES',
          _businessControlCenter.businesses.isEmpty
              ? 'No businesses registered.'
              : _businessControlCenter.businesses.join(', '),
        ),

        _infoCard(
          Icons.pending_actions_outlined,
          'APPROVAL QUEUE',
          '${_businessControlCenter.approvalQueue.pendingCount} item(s) need your attention.',
          onTap: _showApprovalQueue,
          enabled: _businessControlCenter.approvalQueue.pendingCount > 0,
        ),

        const SizedBox(height: 8),
        _sectionTitle('ACTIVITY'),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: const Color(0xFF0B0F18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Text(
            _businessControlCenter.activity.isEmpty
                ? 'No business activity yet.'
                : _businessControlCenter.activity
                      .takeLast(10)
                      .map((entry) => '• $entry')
                      .join('\n'),
            style: const TextStyle(color: Colors.white70, height: 1.5),
          ),
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFFFC107).withValues(alpha: 0.25),
            ),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.security_outlined, color: Color(0xFFFFC107)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'FINANCIAL SAFETY\n'
                  'ETHER cannot spend money, make purchases, '
                  'or create financial commitments autonomously. '
                  'Financial actions require your approval.',
                  style: TextStyle(color: Colors.white70, height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _runBusinessControlCenter() async {
    final goal = _businessGoalController.text.trim();

    if (goal.isEmpty || _businessRunning) {
      return;
    }

    setState(() {
      _businessRunning = true;
    });

    try {
      final result = await _businessControlCenter.runBusinessCheck(goal);

      if (!mounted) {
        return;
      }

      _businessGoalController.clear();

      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('ETHER BUSINESS RESULT'),
            content: SingleChildScrollView(
              child: Text(
                result,
                style: const TextStyle(color: Colors.white70, height: 1.5),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CLOSE'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Business error: $error')));
    } finally {
      if (mounted) {
        setState(() {
          _businessRunning = false;
        });
      }
    }
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

  void _showApprovalQueue() {
    final queue = _businessControlCenter.approvalQueue;

    if (queue.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No approval requests pending.')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B0F18),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'APPROVAL QUEUE',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${queue.pendingCount} item(s) need your attention.',
                  style: const TextStyle(color: Colors.white54),
                ),
                const SizedBox(height: 18),

                ...queue.items.map(
                  (task) => Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF05070D),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFFFC107).withValues(alpha: 0.25),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'APPROVAL REQUIRED',
                          style: TextStyle(
                            color: Color(0xFFFFC107),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          task.goal,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Permission: ${task.permission.name}',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  final approved = await _businessControlCenter
                                      .approve(task);

                                  Navigator.pop(sheetContext);

                                  if (approved && mounted) {
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Business action approved.',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.check_rounded),
                                label: const Text('APPROVE'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  final rejected = _businessControlCenter
                                      .reject(task);

                                  Navigator.pop(sheetContext);

                                  if (rejected && mounted) {
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Business action rejected.',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.close_rounded),
                                label: const Text('REJECT'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoCard(
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
    bool enabled = false,
  }) {
    final card = Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: enabled
              ? const Color(0xFF00E5FF).withValues(alpha: 0.30)
              : Colors.white.withValues(alpha: 0.08),
        ),
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
          if (enabled)
            const Icon(Icons.chevron_right_rounded, color: Colors.white54),
        ],
      ),
    );

    if (onTap == null) {
      return card;
    }

    return GestureDetector(onTap: onTap, child: card);
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

extension<T> on List<T> {
  Iterable<T> takeLast(int count) {
    if (count <= 0) {
      return const [];
    }

    if (length <= count) {
      return this;
    }

    return sublist(length - count);
  }
}
