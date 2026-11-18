import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_new/chat_room_screen.dart';

class _Conv {
  final String roomId;
  final String otherUid;
  final bool iAmNurse;
  final String patientEmail;
  final String lastMessage;
  final String lastTime;
  final bool lastFromMe;

  _Conv({
    required this.roomId,
    required this.otherUid,
    required this.iAmNurse,
    required this.patientEmail,
    required this.lastMessage,
    required this.lastTime,
    required this.lastFromMe,
  });
}

/// Like the "Chats" tab in WhatsApp: shows every conversation of the
/// logged-in user, whether they are the patient or the nurse.
/// Rooms are saved as Chats/<nurseUid>_<patientUid>.
class ChatsListScreen extends StatefulWidget {
  final VoidCallback? onFindNurse;

  const ChatsListScreen({super.key, this.onFindNurse});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  late final Stream<DatabaseEvent> _nurseStream;
  late final Stream<DatabaseEvent> _chatStream;

  static const Color _teal = Color(0xFF00897B);
  static const Color _tealDark = Color(0xFF006064);
  static const Color _tealLight = Color(0xFF00BFA5);

  @override
  void initState() {
    super.initState();
    _nurseStream = FirebaseDatabase.instance.ref('Nurse/postlist').onValue;
    _chatStream = FirebaseDatabase.instance.ref('Chats').onValue;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: user == null
                ? const Center(child: Text('Please log in again.'))
                : _buildBody(user.uid),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(String myUid) {
    return StreamBuilder<DatabaseEvent>(
      stream: _nurseStream,
      builder: (context, nurseSnap) {
        final directory = _parseDirectory(nurseSnap.data?.snapshot.value);

        return StreamBuilder<DatabaseEvent>(
          stream: _chatStream,
          builder: (context, chatSnap) {
            if (chatSnap.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Could not load chats.\n${chatSnap.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (!chatSnap.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: _teal),
              );
            }

            final chats = _parseChats(chatSnap.data!.snapshot.value, myUid);
            if (chats.isEmpty) return _emptyState();

            return ListView.separated(
              padding: const EdgeInsets.only(top: 8, bottom: 20),
              itemCount: chats.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                indent: 88,
                color: Colors.grey.shade200,
              ),
              itemBuilder: (context, index) {
                final c = chats[index];

                // Patient sees the nurse's name/photo, nurse sees patient email
                final String name = c.iAmNurse
                    ? c.patientEmail
                    : (directory[c.otherUid]?['name'] ?? 'Nurse');
                final String? image =
                    c.iAmNurse ? null : directory[c.otherUid]?['image'];

                return _chatRow(
                  context: context,
                  c: c,
                  name: name,
                  image: image,
                );
              },
            );
          },
        );
      },
    );
  }

  Map<String, Map<String, String>> _parseDirectory(Object? value) {
    final out = <String, Map<String, String>>{};
    if (value is! Map) return out;
    value.forEach((_, v) {
      if (v is Map && v['uid'] != null) {
        out[v['uid'].toString()] = {
          'name': (v['pname'] ?? 'Nurse').toString(),
          'image': (v['pImage'] ?? '').toString(),
        };
      }
    });
    return out;
  }

  List<_Conv> _parseChats(Object? value, String myUid) {
    final result = <_Conv>[];
    if (value is! Map) return result;

    value.forEach((roomKey, roomValue) {
      final key = roomKey.toString();
      if (roomValue is! Map) return;

      bool iAmNurse;
      String otherUid;
      if (key.startsWith('${myUid}_')) {
        iAmNurse = true;
        otherUid = key.substring(myUid.length + 1);
      } else if (key.endsWith('_$myUid')) {
        iAmNurse = false;
        otherUid = key.substring(0, key.length - myUid.length - 1);
      } else {
        return; // not my conversation
      }

      final messages = <Map>[];
      roomValue.forEach((_, m) {
        if (m is Map) messages.add(m);
      });
      if (messages.isEmpty) return;

      messages.sort((a, b) =>
          (a['time'] ?? '').toString().compareTo((b['time'] ?? '').toString()));

      final last = messages.last;

      String patientEmail = '';
      if (iAmNurse) {
        for (final m in messages) {
          if (m['senderUid'] != myUid && m['senderEmail'] != null) {
            patientEmail = m['senderEmail'].toString();
            break;
          }
        }
        if (patientEmail.isEmpty) patientEmail = 'Patient';
      }

      result.add(
        _Conv(
          roomId: key,
          otherUid: otherUid,
          iAmNurse: iAmNurse,
          patientEmail: patientEmail,
          lastMessage: (last['message'] ?? '').toString(),
          lastTime: (last['time'] ?? '').toString(),
          lastFromMe: last['senderUid'] == myUid,
        ),
      );
    });

    result.sort((a, b) => b.lastTime.compareTo(a.lastTime));
    return result;
  }

  // ---------- Header ----------
  Widget _buildHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(22, topPadding + 20, 22, 26),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_tealLight, _teal, _tealDark],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chats',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Your conversations',
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.forum_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Chat row ----------
  Widget _chatRow({
    required BuildContext context,
    required _Conv c,
    required String name,
    required String? image,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatRoomScreen(
              roomId: c.roomId,
              title: name,
              subtitle: c.iAmNurse ? 'Patient' : 'Nurse',
              imageUrl: image,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          children: [
            ChatAvatar(name: name, imageUrl: image, radius: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1B2B34),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (c.lastFromMe)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(Icons.done_rounded,
                              size: 16, color: Colors.grey.shade500),
                        ),
                      Expanded(
                        child: Text(
                          c.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.5,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              formatChatTime(c.lastTime),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: _teal.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: _teal,
                size: 46,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'No chats yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1B2B34),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Find a nurse and send a message,\nor wait for a patient to write to you.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            if (widget.onFindNurse != null) ...[
              const SizedBox(height: 22),
              ElevatedButton.icon(
                onPressed: widget.onFindNurse,
                icon: const Icon(Icons.search_rounded),
                label: const Text(
                  'Find a nurse',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 26, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}