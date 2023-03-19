import 'dart:io';
import 'package:archive/archive.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:map_tile/modules/map/map_screen.dart';
import 'package:map_tile/shared/components/components.dart';
import 'package:map_tile/shared/networks/local/cache_helper.dart';
import 'package:map_tile/shared/styles/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock/wakelock.dart';
import '../../shared/constants/constants.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  bool loading = false;
  final Dio dio = Dio();
  double downloadProgress = 0.0;
  File? zippedFile;

  // Function To Save File To Device
  Future<bool> saveFile(String url, String fileName) async {
    Directory directory;
    try {
      // Request Permission For Storage
      if (await _requestPermission(Permission.storage)) {
        directory = (await getExternalStorageDirectory())!;
      } else {
        return false;
      }
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      // If Exists Save file as Zipped File
      if (await directory.exists()) {
        zippedFile = File("${directory.path}/$fileName");
        // Then Start Downloading
        await dio.download(
          url,
          zippedFile!.path,
          onReceiveProgress: (count, total) {
            setState(() {
              // Show Progress
              downloadProgress = count / total;
            });
          },
        );
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  // Function to request permission
  _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  // Main Download Function to make Everything in order
  // Download, Save, Unzip, Proceed
  downloadFile() async {
    setState(() {
      // Prevent Screen Sleep
      Wakelock.enable();
      loading = true;
    });

    bool downloadCompleted = await saveFile(
        "https://www.dropbox.com/s/vu4nzg5f9f13x47/paris.zip?dl=1",
        "paris.zip");
    if (downloadCompleted) {
      showToast(message: "File Downloaded", state: ToastState.SUCCESS);
      setState(() {
        downloaded = true;
      });
      // Start Unzipping (Unarchiving)
      await unarchive(zippedFile);
      showToast(message: "Unarchived Successfully", state: ToastState.SUCCESS);
    } else {
      showToast(
          message: "Problem Downloading The File", state: ToastState.ERROR);
    }

    setState(() {
      loading = false;
      // Disable Lock
      Wakelock.disable();
    });
  }

  // Unarchiving Function
  unarchive(zippedFile) async {
    Directory? appDocDirectory = await getExternalStorageDirectory();
    var bytes = zippedFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File('${appDocDirectory!.path}/$filename')
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory('${appDocDirectory!.path}/$filename').create(recursive: true);
      }
    }
    setState(() {
      unarchived = true;
    });
    // Change Status of downloaded to true and save to Cache
    await CacheHelper.saveData(key: 'downloaded', value: true);
    await CacheHelper.saveData(key: 'unarchived', value: true);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Builder(
        builder: (context) {
          // If didn't Start Download return Button
          if ((loading == false) && (downloaded == false)) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Some Additional Files Need to be downloaded and unarchived",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.black,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        downloadFile();
                      },
                      child: const Text("Download & Archive"),
                    ),
                  ],
                ),
              ),
            );
          }
          // If Started Downloading Show Progress Indicator
          else if ((loading == true) && (downloaded == false)) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Downloading",
                    style: TextStyle(
                      color: primarySwatch,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CircularPercentIndicator(
                    radius: 150,
                    lineWidth: 30,
                    percent: downloadProgress,
                    progressColor: primarySwatch,
                    backgroundColor: fadedSwatch,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text(
                      "${(downloadProgress * 100).round()}%",
                      style: TextStyle(
                        fontSize: 65,
                        color: primarySwatch,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          // After Finish Downloading Show Unarchiving
          else if ((downloaded == true) && (unarchived == false)) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Unarchiving",
                    style: TextStyle(
                      color: primarySwatch,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ConditionalBuilder(
                    condition: true,
                    builder: (context) => const CircularProgressIndicator(),
                    fallback: (context) => Container(),
                  )
                ],
              ),
            );
          } else {
            // At Last Return Map Screen
            return const MapScreen();
          }
        },
      ),
    );
  }
}
