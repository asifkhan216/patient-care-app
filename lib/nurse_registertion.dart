import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
final FirebaseAuth auth = FirebaseAuth.instance;

class NurseRegistron extends StatefulWidget {
  const NurseRegistron({super.key});

  @override
  State<NurseRegistron> createState() => _NurseRegistronState();
}

class _NurseRegistronState extends State<NurseRegistron> {
  bool showSpinner = false;
  final postRef = FirebaseDatabase.instance.ref().child('Nurse');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;

  File? _image;
  final picker = ImagePicker();

  TextEditingController nameController = TextEditingController();
  TextEditingController educacationController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  Future getCameraImage() async {
    final PickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (PickedFile != null) {
        _image = File(PickedFile.path);
      } else {
        print('no image selected');
      }
    });
  }

  Future getImagegallery() async {
    final PickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (PickedFile != null) {
        _image = File(PickedFile.path);
      } else {
        print('no image selected');
      }
    });
  }

  void dialog(context) {
    showDialog(
        context: context,
        builder: (buildcontext) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: SizedBox(
              height: 120,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      getCameraImage();
                      // getImagegallery();
                      Navigator.pop(context);
                    },
                    child: const ListTile(
                      leading: Icon(Icons.camera),
                      title: Text('Camera'),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      getImagegallery();
                      Navigator.pop(context);
                    },
                    child: const ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Gallery'),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 85, 71, 80),
          title: const Text('Registred your self is a Nurse'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    dialog(context);
                  },
                  child: Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * .2,
                      width: MediaQuery.of(context).size.width * .8,
                      child: _image != null
                          ? ClipRect(
                              child: Image.file(
                                _image!.absolute,
                                height: 100,
                                width: 100,
                                fit: BoxFit.fitHeight,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 72, 145, 194),
                                  borderRadius: BorderRadius.circular(10)),
                              width: 100,
                              height: 100,
                              child: const Icon(
                                Icons.camera_alt,
                                color: Color.fromARGB(255, 233, 22, 170),
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Form(
                    child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: 'Doctor Name',
                          hintText: 'Enter You are Name',
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                          labelStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: educacationController,
                      keyboardType: TextInputType.text,
                      minLines: 1,
                      maxLines: 5,
                      decoration: const InputDecoration(
                          labelText: 'Education',
                          hintText: 'Enter your Education',
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                          labelStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: contactController,
                      keyboardType: TextInputType.text,
                      minLines: 1,
                      maxLines: 5,
                      decoration: const InputDecoration(
                          labelText: 'Mobile number',
                          hintText: 'Enter your contact Number',
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                          labelStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: locationController,
                      keyboardType: TextInputType.text,
                      minLines: 1,
                      maxLines: 5,
                      decoration: const InputDecoration(
                          labelText: 'Address',
                          hintText: 'Enter your Location Here',
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                          labelStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal)),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow),
                        child: const Text("Click to Register"),
                        onPressed: () async {
                          setState(
                            () {
                              showSpinner = true;
                            },
                          );
                          try {
                            int data = DateTime.now().microsecondsSinceEpoch;
                           firebase_storage.Reference ref = firebase_storage
   .FirebaseStorage.instance
   .ref('bulid_roor$data');

UploadTask uploadTask =
    ref.putFile(_image!.absolute);

TaskSnapshot snapshot = await uploadTask;


var newurl = await snapshot.ref.getDownloadURL();
print(auth.currentUser!.uid);
print(auth.currentUser!.email);
                            postRef
                                .child('postlist')
                                .child(data.toString())
                                .set({
                                  
  'pid': data.toString(),
  'uid': auth.currentUser!.uid,
  'email': auth.currentUser!.email,

  'pImage': newurl.toString(),
  'ptime': data.toString(),

  'pname': nameController.text.toString(),

  'peducation':
      educacationController.text.toString(),

  'pcontact': contactController.text.toString(),

  'plocation':
      locationController.text.toString(),
})
                            .then((value) {
                              toastmessage('You are register now');
                              setState(() {
                                showSpinner = false;
                              });
                            }).onError((error, stackTrace) {
                              setState(() {
                                showSpinner = false;
                              });
                              toastmessage(error.toString());
                            });
                          } catch (e) {
                            setState(() {
                              showSpinner = true;
                            });
                            toastmessage(e.toString());
                          }
                        })
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void toastmessage(String message) {
  Fluttertoast.showToast(
    msg: message.toString(),
    toastLength: Toast.LENGTH_SHORT,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.white,
    textColor: Colors.black,
    fontSize: 16.0,
  );
}





















// import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_connection_test_project/widgets/round_button.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class AddPostSecreen extends StatefulWidget {
//   const AddPostSecreen({super.key});

//   @override
//   State<AddPostSecreen> createState() => _AddPostSecreenState();
// }

// class _AddPostSecreenState extends State<AddPostSecreen> {
//   bool showSpinner = false;
//   final postRef = FirebaseDatabase.instance.ref().child('post');
//   firebase_storage.FirebaseStorage storage =
//       firebase_storage.FirebaseStorage.instance;

//   File? _image;
//   final picker = ImagePicker();
//   TextEditingController descriptionController = TextEditingController();
//   TextEditingController titleController = TextEditingController();
//   Future getCameraImage() async {
//     final PickedFile = await picker.pickImage(source: ImageSource.camera);
//     setState(() {
//       if (PickedFile != null) {
//         _image = File(PickedFile.path);
//       } else {
//         print('no image selected');
//       }
//     });
//   }

//   Future getImagegallery() async {
//     final PickedFile = await picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       if (PickedFile != null) {
//         _image = File(PickedFile.path);
//       } else {
//         print('no image selected');
//       }
//     });
//   }

//   void dialog(context) {
//     showDialog(
//         context: context,
//         builder: (buildcontext) {
//           return AlertDialog(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             content: Container(
//               height: 120,
//               child: Column(
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       getCameraImage();
//                       // getImagegallery();
//                       Navigator.pop(context);
//                     },
//                     child: ListTile(
//                       leading: Icon(Icons.camera),
//                       title: Text('Camera'),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       getImagegallery();
//                       Navigator.pop(context);
//                     },
//                     child: ListTile(
//                       leading: Icon(Icons.photo_library),
//                       title: Text('Gallery'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ModalProgressHUD(
//       inAsyncCall: showSpinner,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('upload doctor data'),
//           centerTitle: true,
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//             child: Column(
//               children: [
//                 InkWell(
//                   onTap: () {
//                     dialog(context);
//                   },
//                   child: Center(
//                     child: Container(
//                       height: MediaQuery.of(context).size.height * .2,
//                       width: MediaQuery.of(context).size.width * .8,
//                       child: _image != null
//                           ? ClipRect(
//                               child: Image.file(
//                                 _image!.absolute,
//                                 height: 100,
//                                 width: 100,
//                                 fit: BoxFit.fitHeight,
//                               ),
//                             )
//                           : Container(
//                               decoration: BoxDecoration(
//                                   color: Colors.grey.shade400,
//                                   borderRadius: BorderRadius.circular(10)),
//                               width: 100,
//                               height: 100,
//                               child: Icon(
//                                 Icons.camera_alt,
//                                 color: Colors.blue,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 25,
//                 ),
//                 Form(
//                     child: Column(
//                   children: [
//                     TextFormField(
//                       controller: titleController,
//                       keyboardType: TextInputType.text,
//                       decoration: InputDecoration(
//                           labelText: 'Title',
//                           hintText: 'Enter post Title',
//                           border: OutlineInputBorder(),
//                           hintStyle: TextStyle(
//                               color: Colors.grey,
//                               fontWeight: FontWeight.normal),
//                           labelStyle: TextStyle(
//                               color: Colors.grey,
//                               fontWeight: FontWeight.normal)),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     TextFormField(
//                       controller: descriptionController,
//                       keyboardType: TextInputType.text,
//                       minLines: 1,
//                       maxLines: 5,
//                       decoration: InputDecoration(
//                           labelText: 'Description',
//                           hintText: 'Enter post  description',
//                           border: OutlineInputBorder(),
//                           hintStyle: TextStyle(
//                               color: Colors.grey,
//                               fontWeight: FontWeight.normal),
//                           labelStyle: TextStyle(
//                               color: Colors.grey,
//                               fontWeight: FontWeight.normal)),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     RoundButton(
//                         title: 'Upload',
//                         onTap: () async {
//                           setState(() {
//                             showSpinner = true;
//                           });
//                           try {
//                             int data = DateTime.now().microsecondsSinceEpoch;
//                             firebase_storage.Reference ref = firebase_storage
//                                 .FirebaseStorage.instance
//                                 .ref('/bulid_roor$data');
//                             UploadTask uploadTask =
//                                 ref.putFile(_image!.absolute);
//                             await Future.value(uploadTask);
//                             var newurl = await ref.getDownloadURL();
//                             // final User? user = _auth.currentUser;
//                             postRef
//                                 .child('postlist')
//                                 .child(data.toString())
//                                 .set({
//                               'pid': data.toString(),
//                               'pImage': newurl.toString(),
//                               'ptime': data.toString(),
//                               'ptitle': titleController.text.toString(),
//                               'pDescription':
//                                   descriptionController.text.toString(),
//                               // 'uEmail': user!.email.toString(),
//                               // 'uid': user!.uid.toString(),
//                             }).then((value) {
//                               toastmessage('post Published');
//                               setState(() {
//                                 showSpinner = false;
//                               });
//                             }).onError((error, stackTrace) {
//                               setState(() {
//                                 showSpinner = false;
//                               });
//                               toastmessage(error.toString());
//                             });
//                           } catch (e) {
//                             setState(() {
//                               showSpinner = true;
//                             });
//                             toastmessage(e.toString());
//                           }
//                         })
//                   ],
//                 ))
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// void toastmessage(String message) {
//   Fluttertoast.showToast(
//     msg: message.toString(),
//     toastLength: Toast.LENGTH_SHORT,
//     timeInSecForIosWeb: 1,
//     backgroundColor: Colors.white,
//     textColor: Colors.black,
//     fontSize: 16.0,
//   );
// }
