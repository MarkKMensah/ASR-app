import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SessionScreen extends StatefulWidget {
  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  final record = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _audioPath;
  bool _isRecording = false;
  String _errorMessage = '';
  Duration _recordDuration = Duration.zero;
  List<Map<String, dynamic>> prompts = [];
  int currentPromptIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPrompts();
    _checkPermissions();
    _startTimer();
  }

  Future<void> _loadPrompts() async {
    setState(() {
      prompts = [
        {"title": "Dwen Hwɛ Kan", "english": "Think before you speak"},
        {"title": "Me ma wo akye", "english": "Good morning"},
        {"title": "Wo ho te sɛn", "english": "How are you?"},
        {"title": "Me da wo ase", "english": "Thank you"},
        {"title": "Yɛ bɛ hyia bio", "english": "We'll meet again"},
        {"title": "Me te aseɛ", "english": "I understand"},
        {"title": "Me suro", "english": "I am afraid"},
        {"title": "Ɛyɛ", "english": "It is good"}
      ];
    });
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isRecording) {
        setState(() {
          _recordDuration = Duration(seconds: _recordDuration.inSeconds + 1);
        });
        _startTimer();
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<void> _checkPermissions() async {
    try {
      final hasPermission = await record.hasPermission();
      if (!hasPermission) {
        setState(() {
          _errorMessage = 'Microphone permission not granted';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error checking permissions: $e';
      });
    }
  }

  Future<void> _startRecording() async {
    try {
      if (!await record.hasPermission()) {
        setState(() {
          _errorMessage = 'Microphone permission not granted';
        });
        return;
      }

      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await record.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );

      setState(() {
        _isRecording = true;
        _audioPath = path;
        _errorMessage = '';
        _recordDuration = Duration.zero;
      });
      _startTimer();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error starting recording: $e';
        _isRecording = false;
      });
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await record.stop();
      setState(() {
        _isRecording = false;
        _audioPath = path;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error stopping recording: $e';
        _isRecording = false;
      });
    }
  }

  Future<void> _playAudio() async {
    try {
      if (_audioPath != null) {
        await _audioPlayer.play(DeviceFileSource(_audioPath!));
      } else {
        setState(() {
          _errorMessage = 'No audio to play';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error playing audio: $e';
      });
    }
  }

  Future<void> _deleteRecording() async {
    try {
      if (_audioPath != null) {
        final file = File(_audioPath!);
        if (await file.exists()) {
          await file.delete();
        }
        setState(() {
          _audioPath = null;
          _errorMessage = '';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error deleting recording: $e';
      });
    }
  }

  @override
  void dispose() {
    record.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushNamed(context, "/home"),
        ),
        title: Text(
          'Session 1',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              '${currentPromptIndex + 1}/${prompts.length}',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                prompts.length,
                    (index) => Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    height: 4,
                    decoration: BoxDecoration(
                      color: index <= currentPromptIndex ? Colors.black : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),

            if (prompts.isNotEmpty) Column(
              children: [
                Text(
                  prompts[currentPromptIndex]['title'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  prompts[currentPromptIndex]['english'],
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            Container(
              height: 190,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isRecording
                          ? 'Recording... ${_formatDuration(_recordDuration)}'
                          : _audioPath != null
                          ? 'Recording saved'
                          : 'Ready to record',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.grey[700],
                      ),
                    ),
                    if (_audioPath != null && !_isRecording)
                      IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: _playAudio,
                      ),
                  ],
                ),
              ),
            ),
            Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    size: 32,
                    color: _audioPath != null ? Colors.grey[700] : Colors.grey[300],
                  ),
                  onPressed: _audioPath != null ? _deleteRecording : null,
                ),
                FloatingActionButton(
                  backgroundColor: _isRecording ? Colors.red : Colors.black,
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    size: 32,
                    color: _audioPath != null ? Colors.grey[700] : Colors.grey[300],
                  ),
                  onPressed: _audioPath != null
                      ? () {
                    if (currentPromptIndex < prompts.length - 1) {
                      setState(() {
                        currentPromptIndex++;
                        _audioPath = null;
                      });
                    } else {
                      Navigator.pushNamed(context, "/home");
                    }
                  }
                      : null,
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}