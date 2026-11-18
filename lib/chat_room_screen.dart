import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// "14:05" for today, "17/11" for older messages.
String formatChatTime(String raw) {
  final t = DateTime.tryParse(raw);
  if (t == null) return '';
  String two(int n) => n.toString().padLeft(2, '0');
  final now = DateTime.now();
  final sameDay =
      t.year == now.year && t.month == now.month && t.day == now.day;
  return sameDay
      ? '${two(t.hour)}:${two(t.minute)}'
      : '${two(t.day)}/${two(t.month)}';
}

/// Round avatar: shows the photo if there is one, otherwise the first letter.
class ChatAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double radius;

  const ChatAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.radius = 26,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage =
        imageUrl != null && imageUrl!.isNotEmpty && imageUrl != 'null';

    final initial = Container(
      width: radius * 2,
      height: radius * 2,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00BFA5), Color(0xFF006064)],
        ),
      ),
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );

    if (!hasImage) return initial;

    return ClipOval(
      child: Image.network(
        imageUrl!,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => initial,
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : initial,
      ),
    );
  }
}

/// One conversation (room). Used by the patient AND the nurse.
/// Messages live in Chats/<roomId> with the same fields as before.
class ChatRoomScreen extends StatefulWidget {
  final String roomId;
  final String title;
  final String subtitle;
  final String? imageUrl;

  const ChatRoomScreen({
    super.key,
    required this.roomId,
    required this.title,
    this.subtitle = '',
    this.imageUrl,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  late final DatabaseReference chatRef;
  late final Stream<DatabaseEvent> _stream;
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  static const Color _teal = Color(0xFF00897B);
  static const Color _tealDark = Color(0xFF006064);
  static const Color _tealLight = Color(0xFF00BFA5);

  @override
  void initState() {
    super.initState();
    chatRef = FirebaseDatabase.instance.ref("Chats/${widget.roomId}");
    _stream = chatRef.onValue;
  }

  @override
  void dispose() {
    messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser!;
    messageController.clear();

    await chatRef.push().set({
      "message": text,
      "senderUid": user.uid,
      "senderEmail": user.email,
      "time": DateTime.now().toString(),
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _dateLabel(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(d.year, d.month, d.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFFE6F0EE),
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Could not load messages.\n${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  final value = snapshot.data?.snapshot.value;
                  if (value == null || value is! Map) {
                    return _emptyState();
                  }

                  final items = value.values.whereType<Map>().toList()
                    ..sort((a, b) => (a['time'] ?? '')
                        .toString()
                        .compareTo((b['time'] ?? '').toString()));

                  final children = <Widget>[];
                  String? lastDay;
                  for (final item in items) {
                    final timeRaw = (item['time'] ?? '').toString();
                    final dt = DateTime.tryParse(timeRaw);
                    if (dt != null) {
                      final dayKey = '${dt.year}-${dt.month}-${dt.day}';
                      if (dayKey != lastDay) {
                        children.add(_dateChip(_dateLabel(dt)));
                        lastDay = dayKey;
                      }
                    }
                    children.add(
                      _bubble(
                        text: item["message"].toString(),
                        time: formatChatTime(timeRaw),
                        isMe: item["senderUid"] == currentUid,
                      ),
                    );
                  }

                  _scrollToBottom();

                  return ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    children: children,
                  );
                },
              ),
            ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  // ---------- Header ----------
  Widget _buildHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(6, topPadding + 6, 12, 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_tealLight, _teal, _tealDark],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: ChatAvatar(
              name: widget.title,
              imageUrl: widget.imageUrl,
              radius: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (widget.subtitle.isNotEmpty)
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Date chip ----------
  Widget _dateChip(String label) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  // ---------- Message bubble ----------
  Widget _bubble({
    required String text,
    required String time,
    required bool isMe,
  }) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.fromLTRB(12, 8, 10, 6),
        decoration: BoxDecoration(
          color: isMe ? _teal : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 3),
            bottomRight: Radius.circular(isMe ? 3 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: isMe ? Colors.white : const Color(0xFF1B2B34),
                ),
              ),
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: isMe ? Colors.white70 : Colors.grey.shade500,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.done_rounded,
                      size: 15, color: Colors.white70),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.waving_hand_rounded, color: _teal, size: 36),
            const SizedBox(height: 10),
            Text(
              'Say hello to ${widget.title}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1B2B34),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Input bar ----------
  Widget _buildInputBar() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: messageController,
                  minLines: 1,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Message',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 13),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: _teal,
              shape: const CircleBorder(),
              elevation: 3,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _sendMessage,
                child: const SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(Icons.send_rounded, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}