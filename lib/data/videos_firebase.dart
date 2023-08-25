import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:somtok/data/video.dart';

import 'demo_data.dart';


class VideosAPI {
  List<Video> listVideos = <Video>[];

  VideosAPI() {
    _load();
  }

  Future<void> _load() async {
    listVideos = await _getVideoList();
  }

  Future<List<Video>> _getVideoList() async {
    try {
      var data = await FirebaseFirestore.instance.collection("Videos").get();

      if (data.docs.isEmpty) {
        await _addDemoData();
        data = await FirebaseFirestore.instance.collection("Videos").get();
      }

      return data.docs.map((doc) => Video.fromJson(doc.data())).toList();
    } catch (e) {
      print("Error fetching videos: $e");
      return [];
    }
  }

  Future<void> _addDemoData() async {
    for (var video in data) {
      // Provide a specific document ID when setting demo data
      await FirebaseFirestore.instance
          .collection("Videos")
          .doc(video["id"])
          .set(video);
    }
  }
}
