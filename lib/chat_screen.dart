import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_new/chat_room_screen.dart';

/// Opened from the nurse profile ("Chat With Nurse").
/// Same constructor as before, plus an optional nurse photo.
/// The room is still Chats/<nurseUid>_<patientUid>.
class ChatScreen extends StatelessWidget {
  final String nurseName;
  final String nurseUid;
  final String? nurseImageUrl;

  const ChatScreen({
    Key? key,
    required this.nurseName,
    required this.nurseUid,
    this.nurseImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String patientUid = FirebaseAuth.instance.currentUser!.uid;
    final String roomId = "${nurseUid}_$patientUid";

    return ChatRoomScreen(
      roomId: roomId,
      title: nurseName,
      subtitle: 'Nurse',
      imageUrl: nurseImageUrl,
    );
  }
}