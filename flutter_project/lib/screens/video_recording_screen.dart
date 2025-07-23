import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({Key? key}) : super(key: key);

  @override
  _VideoRecordingScreenState createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isRecording = false;
  bool _isPaused = false;
  Timer? _timer;
  int _recordDuration = 0;
  List<File> _recordedVideos = [];
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras!.first,
        ResolutionPreset.high,
        enableAudio: true,
      );
      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() {});
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordDuration++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _recordDuration = 0;
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _startRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
      await _cameraController!.startVideoRecording();
      setState(() {
        _isRecording = true;
        _isPaused = false;
      });
      _startTimer();
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (_cameraController == null || !_cameraController!.value.isRecordingVideo) return;
    try {
      final file = await _cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _isPaused = false;
        _recordedVideos.add(File(file.path));
      });
      _stopTimer();
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
  }

  Future<void> _pauseRecording() async {
    if (_cameraController == null || !_cameraController!.value.isRecordingVideo) return;
    try {
      await _cameraController!.pauseVideoRecording();
      setState(() {
        _isPaused = true;
      });
      _timer?.cancel();
    } catch (e) {
      debugPrint('Error pausing recording: $e');
    }
  }

  Future<void> _resumeRecording() async {
    if (_cameraController == null || !_cameraController!.value.isRecordingVideo) return;
    try {
      await _cameraController!.resumeVideoRecording();
      setState(() {
        _isPaused = false;
      });
      _startTimer();
    } catch (e) {
      debugPrint('Error resuming recording: $e');
    }
  }

  void _playVideo(File videoFile) {
    _videoPlayerController?.dispose();
    _videoPlayerController = VideoPlayerController.file(videoFile)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController!.play();
      });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _videoPlayerController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Recording'),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: _cameraController!.value.aspectRatio,
            child: CameraPreview(_cameraController!),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Duration: ${_formatDuration(_recordDuration)}',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isRecording)
                ElevatedButton(
                  onPressed: _startRecording,
                  child: const Text('Record'),
                ),
              if (_isRecording && !_isPaused)
                ElevatedButton(
                  onPressed: _pauseRecording,
                  child: const Text('Pause'),
                ),
              if (_isRecording && _isPaused)
                ElevatedButton(
                  onPressed: _resumeRecording,
                  child: const Text('Resume'),
                ),
              if (_isRecording)
                ElevatedButton(
                  onPressed: _stopRecording,
                  child: const Text('Stop'),
                ),
            ],
          ),
          const Divider(),
          const Text('Recorded Videos:', style: TextStyle(fontSize: 18)),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _recordedVideos.length,
              itemBuilder: (context, index) {
                final videoFile = _recordedVideos[index];
                return GestureDetector(
                  onTap: () => _playVideo(videoFile),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    width: 100,
                    color: Colors.black12,
                    child: Center(
                      child: Icon(
                        Icons.videocam,
                        size: 50,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_videoPlayerController != null && _videoPlayerController!.value.isInitialized)
            AspectRatio(
              aspectRatio: _videoPlayerController!.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController!),
            ),
        ],
      ),
    );
  }
}
