import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoUploadPage extends StatefulWidget {
  @override
  _VideoUploadPageState createState() => _VideoUploadPageState();
}

class _VideoUploadPageState extends State<VideoUploadPage> {
  File? selectedVideo;
  VideoPlayerController? videoPlayerController;
  bool isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.asset("assets/sample_video.mp4")
      ..initialize().then((_) {
        // Ensure the first frame is shown
        setState(() {});
      });
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> _selectVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedVideo = File(pickedFile.path);
        videoPlayerController = VideoPlayerController.file(selectedVideo!)
          ..initialize().then((_) {
            // Ensure the first frame is shown
            setState(() {});
          });
      });
    }
  }

  void _togglePlay() {
    setState(() {
      isVideoPlaying = !isVideoPlaying;
      if (isVideoPlaying) {
        videoPlayerController?.play();
      } else {
        videoPlayerController?.pause();
      }
    });
  }
void _uploadVideo() async {
  if (selectedVideo == null) {
    return;
  }

  final storage = FirebaseStorage.instance;
  final videoRef = storage.ref().child('videos/${DateTime.now().millisecondsSinceEpoch}.mp4');
  final uploadTask = videoRef.putFile(selectedVideo!);

  try {
    // Wait for the upload task to complete
    final uploadSnapshot = await uploadTask;
    final videoUrl = await uploadSnapshot.ref.getDownloadURL();

    // Store the video URL in Firestore
    await FirebaseFirestore.instance.collection('Videos').add({
      'videoUrl': videoUrl,
    });

    setState(() {
      selectedVideo = null;
      isVideoPlaying = false;
      videoPlayerController!.pause();
    });
 print('uploaded video');
    // Show success notification
   ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Video uploaded successfully.'),
      duration: Duration(seconds: 2),
    ),
  );
  } catch (error) {
    print('Error uploading video: $error');

    // Show error notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error uploading video. Please try again.'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Upload a Video',style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(
            icon: Icon(Icons.video_library,color: Colors.black,),
            onPressed: _selectVideo,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child:Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    if (videoPlayerController != null && videoPlayerController!.value.isInitialized)
      GestureDetector(
        onTap: _togglePlay,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * videoPlayerController!.value.aspectRatio,
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(videoPlayerController!),
              if (!isVideoPlaying)
                Icon(
                  Icons.play_arrow,
                  size: 50,
                ),
            ],
          ),
        ),
      ),
    SizedBox(height: 20),
    if (selectedVideo != null)
      ElevatedButton(
        onPressed: _uploadVideo,
        child: Text('Post Video'),
      ),
  ],
),

      ),
    );
  }
}
