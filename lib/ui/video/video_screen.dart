import 'dart:io';

import 'package:camera/camera.dart';
import 'package:chatapp_third/helper/firebase_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class VideoScreen extends StatefulWidget {
  VideoScreen({super.key, required this.camera});
  final CameraDescription camera;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  UploadTask? task;
  File? file;

  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _cameraController.initialize();
    // initializeCamera();
  }

  // Future<void> initializeCamera() async {
  //   // widget.camera = await availableCameras();
  //   // if (cameras.isEmpty) {
  //   //   print('No cameras available');
  //   //   return;
  //   // }

  //   try {
  //     await _cameraController?.initialize();
  //   } catch (e) {
  //     print('Error initializing camera: $e');
  //   }

  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
    if (result == null) {
      return null;
    }
    final path = result.files.single.path;
    setState(() {
      file = File(path!);
    });
  }

  void uploadfile() async {
    if (file == null) {
      return;
    }
    final filename = file!.path;
    final destination = 'files/$filename';
    task = FirebaseHelper.uploadTask(destination, file!);
    if (task == null) {
      return;
    }
    final snapshot = await task!.whenComplete(() {});
    final urlDounload = await snapshot.ref.getDownloadURL();
    print("Dounloaded Url is : $urlDounload");
  }

  void uploadVideoFile(File recordedVideo) async {
    if (recordedVideo == null) {
      return;
    }
    final filename = recordedVideo.path;
    final destination = 'files/$filename';
    task = FirebaseHelper.uploadTask(destination, recordedVideo);
    if (task == null) {
      return;
    }
    final snapshot = await task!.whenComplete(() {});
    final urlDounload = await snapshot.ref.getDownloadURL();
    print("Dounloaded Url is : $urlDounload");
  }

  Future<String?> startVideoRecording() async {
    // final recordingPath = (await getTemporaryDirectory()).path +
    //     '/${DateTime.now().millisecondsSinceEpoch}.mp4';
    try {
      await _cameraController.startVideoRecording();

      setState(() {
        _isRecording = true;
      });

      // await _cameraController?.stopVideoRecording();

      // final recordedVideo = File(recordingPath);
      // uploadVideoFile(recordedVideo);
    } catch (e) {
      print('Error recording and uploading video: $e');
      return '';
    }
  }

  Future<String?> stopVideoRecording() async {
    final recordingPath = (await getTemporaryDirectory()).path +
        '/${DateTime.now().millisecondsSinceEpoch}.mp4';
    try {
      await _cameraController.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });
      final recordedVideo = File(recordingPath);
      uploadVideoFile(recordedVideo);
    } catch (e) {
      print('Error recording and uploading video: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // final filename = file != null ? file!.path : 'No File Selected';
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CameraPreview(_cameraController);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.photo_size_select_actual),
                  iconSize: 30,
                  color: Colors.blue,
                  onPressed: () {
                    selectFile();
                  },
                ),
                // SizedBox(
                //   height: 10,
                // ),
                // Text(
                //   filename,
                //   textAlign: TextAlign.center,
                // ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: Icon(Icons.upload_file),
                  iconSize: 30,
                  color: Colors.green.shade500,
                  onPressed: () {
                    uploadfile();
                  },
                ),
                // SizedBox(
                //   height: 10,
                // ),
                // task != null ? buildUploadTaskStatus(task!) : Container(),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: Icon(Icons.camera),
                  iconSize: 30,
                  color: Colors.blueGrey,
                  onPressed: () {
                    // uploadfile();
                    startVideoRecording();
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: Icon(Icons.stop_circle),
                  iconSize: 30,
                  color: Colors.red.shade500,
                  onPressed: () {
                    // uploadfile();
                    stopVideoRecording();
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                if (_isRecording)
                  IconButton(
                    icon: Icon(Icons.emergency_recording),
                    iconSize: 30,
                    color: Colors.orange.shade500,
                    onPressed: () {
                      // uploadfile();
                    },
                  ),
              ],
            ),
          ],
        ),
      )),
    );
  }

  Widget buildUploadTaskStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data;
            final progress = snap!.bytesTransferred / snap.totalBytes;
            final persentage = (progress * 100).toStringAsFixed(2);
            return Text("$persentage %");
          } else {
            return Container();
          }
        },
      );
}
