// ignore: depend_on_referenced_packages

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splash_screen_new/search_nearset_nurse.dart';

// import '../../doctor_profile.dart';
// import '../../upload_pic.dart';

class ResiveData extends StatefulWidget {
  const ResiveData({super.key});
  @override
  State<ResiveData> createState() => _ResiveDataState();
}

class _ResiveDataState extends State<ResiveData> {
  final dbref = FirebaseDatabase.instance.ref().child('Nurse');
  TextEditingController searchController = TextEditingController();
  String search = "";

  // Theme colors (same as the other screens)
  static const Color _teal = Color(0xFF00897B);
  static const Color _tealDark = Color(0xFF006064);
  static const Color _tealLight = Color(0xFF00BFA5);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F6F6),
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: FirebaseAnimatedList(
                query: dbref.child('postlist'),
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  String imageurl = snapshot.child('pImage').value.toString();
                  String education =
                      snapshot.child('peducation').value.toString();
                  String location =
                      snapshot.child('plocation').value.toString();
                  String tempname = snapshot.child('pname').value.toString();
                  String contact = snapshot.child('pcontact').value.toString();
                  String nurseUid = snapshot.child('uid').value.toString();

                  final query = searchController.text.trim().toLowerCase();

                  if (query.isEmpty || location.toLowerCase().contains(query)) {
                    return SizeTransition(
                      sizeFactor: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: _nurseCard(
                          context: context,
                          imageUrl: imageurl,
                          name: tempname,
                          education: education,
                          location: location,
                          contact: contact,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NextScreen(
                                  name: tempname,
                                  education: education,
                                  location: location,
                                  contact: contact,
                                  imageUrl: imageurl,
                                  nurseUid: nurseUid,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Header with search ----------
  Widget _buildHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, topPadding + 8, 16, 26),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.maybePop(context),
              ),
              const SizedBox(width: 4),
              const Expanded(
                child: Text(
                  'Find Nearby Nurse',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medical_services_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 52, top: 2, bottom: 18),
            child: Text(
              'Search by location and connect with a nurse',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),

          // Search field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search for the nearest nurse',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: const Icon(Icons.search_rounded, color: _teal),
                suffixIcon: searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: Icon(Icons.close_rounded,
                            color: Colors.grey.shade600),
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            search = "";
                          });
                        },
                      ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onChanged: (String value) {
                setState(() {
                  search = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Nurse card ----------
  Widget _nurseCard({
    required BuildContext context,
    required String imageUrl,
    required String name,
    required String education,
    required String location,
    required String contact,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: _tealDark.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo with location chip
                  Stack(
                    children: [
                      Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                          width: double.infinity,
                          height: 200,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [_tealLight, _tealDark],
                            ),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Colors.white70,
                            size: 80,
                          ),
                        ),
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            width: double.infinity,
                            height: 200,
                            color: const Color(0xFFD9ECEA),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: _teal,
                                strokeWidth: 3,
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 70,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.55),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 14,
                        bottom: 12,
                        right: 14,
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_rounded,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Details
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1B2B34),
                                ),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _teal.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_rounded,
                                color: _teal,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _infoRow(Icons.school_rounded, education),
                        const SizedBox(height: 8),
                        _infoRow(Icons.phone_rounded, contact),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F6F6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: _teal, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
          ),
        ),
      ],
    );
  }
}