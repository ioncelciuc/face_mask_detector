import 'package:camera/camera.dart';
import 'package:face_mask_detector/main.dart';
import 'package:flutter/material.dart';

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
                }
            });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initCamera(activeCamera);
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
          FloatingActionButton(
            child: Icon(Icons.flip_camera_ios_rounded),
            onPressed: () {
              setState(() {
                if (activeCamera == 0)
                  activeCamera = 1;
                else
                  activeCamera = 0;
                isFlashOn = false;
                initCamera(activeCamera);
              });
            },
          ),
          SizedBox(width: 16),
          FloatingActionButton(
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
