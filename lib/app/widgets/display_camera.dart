import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription>? cameras;
  bool isDoneCapture = false;
  XFile? image;

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;
    if (arguments['lensDirection'] != null) {
      _getAvailableCameras(lensDirection: arguments['lensDirection']);
    } else {
      _getAvailableCameras();
    }
  }

  // get available cameras
  Future<void> _getAvailableCameras({CameraLensDirection lensDirection = CameraLensDirection.front}) async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    CameraDescription selectedCamera = cameras!.firstWhere((camera) => (camera.lensDirection == lensDirection));
    _initCamera(selectedCamera);
  }

  // init camera
  Future<void> _initCamera(CameraDescription description) async {
    _controller = CameraController(
      description, 
      ResolutionPreset.max, 
      enableAudio: false
    );

    try{
      await _controller!.initialize();
      setState((){}); 
    }
    catch(e){
      debugPrint(e.toString());
    }  
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF457B9D),
        title: const Text('Ambil Foto Selfie'),
      ),
      body: 
        (_controller != null)
        ?
          (!_controller!.value.isInitialized)
          ? 
            const Center(child: CircularProgressIndicator())
          : 
            (isDoneCapture)
            ?
              previewImage()
            :
            Center(child: CameraPreview(_controller!))
        : const Center(child: CircularProgressIndicator())
      ,
      bottomSheet: (!isDoneCapture) 
      ?
        Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                color: Colors.white,
                onPressed: () {
                  Get.back();
                }, 
                icon: const Icon(Icons.close),
              ),
              FloatingActionButton(
                heroTag: "CAPTURE_BUTTON_CAMERA",
                onPressed: () async {
                  try {
                    await _initializeControllerFuture;
                    
                    image = await _controller!.takePicture();
                    isDoneCapture = true;
                    setState(() {});
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
                child: const Icon(Icons.camera_alt),
              ),
              IconButton(
                color: Colors.white,
                onPressed: () {
                  _getAvailableCameras(lensDirection: (_controller!.description.lensDirection == CameraLensDirection.front) ? CameraLensDirection.back : CameraLensDirection.front);
                }, 
                icon: const Icon(Icons.flip_camera_android),
              ),
            ],
          ),
        )
      : 
        Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton(
                heroTag: "BACK_BUTTON_CAMERA",
                backgroundColor: Colors.red,
                onPressed: () => setState(() => isDoneCapture = false),
                child: const Icon(Icons.close),
              ),
              FloatingActionButton(
                heroTag: "NEXT_BUTTON_CAMERA",
                backgroundColor: Colors.green,
                onPressed: () {
                  return Get.back(result: image);
                },
                child: const Icon(Icons.done),
              )
            ],
          ),
        ),
    );
  }

  Widget previewImage() {
    return Image.file(File(image!.path));
  }
}