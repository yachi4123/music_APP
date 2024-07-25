import 'package:app1/music_controller.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DownloadController extends GetxController {
  MusicController musicController = Get.find<MusicController>();
  List<FileSystemEntity> SongFiles = [];
  List<FileSystemEntity> ImagesFiles = [];
  Directory? downloadDirectory;
  Directory? songsDirectory;
  Directory? imagesDirectory;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> initializeDownloadDirectory() async {
    try {
      final Directory? downloadDirectory;
      if(Platform.isIOS) {
        downloadDirectory = await getApplicationDocumentsDirectory();
      } else {
        downloadDirectory = await getExternalStorageDirectory();
      }

      if (downloadDirectory != null) {
        // Create songs and images directories
        final Directory? songsDirectory =  Directory('${downloadDirectory.path}/songs');
        final Directory? imagesDirectory = Directory('${downloadDirectory.path}/images');

        if (!await songsDirectory!.exists()) {
          await songsDirectory.create(recursive: true);
        }
        if (!await imagesDirectory!.exists()) {
          await imagesDirectory.create(recursive: true);
        }

        final songFiles = songsDirectory.listSync(recursive: true);
        final imageFiles = imagesDirectory.listSync(recursive: true);
        musicController.downloads.assignAll(songFiles);
        musicController.images.assignAll(imageFiles);
      }
    } catch (e) {
      print(e);
    }
  }


  Future<void> deleteFile(FileSystemEntity file) async {
    try {
      await file.delete();
      initializeDownloadDirectory();
    } catch (e) {
      print('Delete failed: $e');
    }
  }

}
