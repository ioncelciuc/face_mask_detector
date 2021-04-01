import 'package:camera/camera.dart';
import 'package:face_mask_detector/main.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CameraImage cameraImage;
  CameraController cameraController;
  bool isWorking = false;
  String result = "";
  int activeCamera = 0;
  bool isFlashOn = false;

  void initCamera(int cameraIndex) {
    cameraController = CameraController(
      cameras[cameraIndex],
      ResolutionPreset.max,
    );
    cameraController.initialize().then((value) {
      if (!mounted) return;
      setState(() {
        cameraController.startImageStream((image) => {
              if (!isWorking)
                {
                  isWorking = true,
                  cameraImage = image,
                  runModelOnFrame(),
                }
            });
      });
    });
  }

  void loadModel() async {
    Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  void runModelOnFrame() async {
    if (cameraImage != null) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: cameraImage.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 1,
        threshold: 0.1,
        asynch: true,
      );

      result = '';

      recognitions.forEach((response) {
        result += response['label'] + '\n';
      });

      setState(
        () {},
      );

      isWorking = false;
    }
  }

  @override
  void initState() {
    super.initState();
    initCamera(activeCamera);
    loadModel();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  result,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          // FloatingActionButton(
          //   heroTag: 'change_camera',
          //   child: Icon(Icons.flip_camera_ios_rounded),
          //   onPressed: () {
          //     setState(() {
          //       if (activeCamera == 0)
          //         activeCamera = 1;
          //       else
          //         activeCamera = 0;
          //       isFlashOn = false;
          //       initCamera(activeCamera);
          //     });
          //   },
          // ),
          FloatingActionButton(
            heroTag: 'flash',
            child: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: () {
              setState(() {
                if (isFlashOn) {
                  isFlashOn = false;
                  cameraController.setFlashMode(FlashMode.off);
                } else {
                  if (cameraController.description == cameras[0]) {
                    isFlashOn = true;
                    cameraController.setFlashMode(FlashMode.torch);
                  }
                }
              });
            },
          ),
        ],
      ),
      body: Container(
        child: !cameraController.value.isInitialized
            ? Container()
            : CameraPreview(cameraController),
      ),
    );
  }
}
