import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:io';


class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  final record = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? _audioPath;
  bool _isRecording = false;
  String _errorMessage = '';
  Duration _recordDuration = Duration.zero;
  List<Map<String, dynamic>> prompts = [];
  int currentPromptIndex = 0;
  bool _isLoading = true;
  bool _isSubmitting = false;
  Map<int, String> _promptRecordings = {};

  @override
  void initState() {
    super.initState();
    _loadPrompts();
    _checkPermissions();
    _startTimer();
    _uploadRecording();
    _generateUniqueId();
  }

  Future<void> _loadPrompts() async {
    try {
      final String? token = await _secureStorage.read(key: 'accessToken');

      if (token == null) {
        setState(() {
          _errorMessage = 'Not authenticated';
          _isLoading = false;
        });
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final response = await http.get(
        Uri.parse(
            'https://akan-recorder-backend-y5er.onrender.com/texts/random'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          prompts = data
              .map((prompt) => {
                    'title': prompt['content'],
                    'english': prompt['translation'],
                    'id': prompt['id'],
                    'prerecord': prompt['prerecord'],
                    'created_at': prompt['created_at'],
                  })
              .toList();
          _isLoading = false;
        });
      } else if (response.statusCode == 401) {
        // Token expired or invalid
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        setState(() {
          _errorMessage = 'Failed to load prompts';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading prompts: $e';
        _isLoading = false;
      });
    }
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
      final uniqueId = _generateUniqueId();
      final path = '${directory.path}/audio_$uniqueId.m4a';

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

  String _generateUniqueId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(10, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  Future<void> _stopRecording() async {
    try {
      final path = await record.stop();
      setState(() {
        _isRecording = false;
        _audioPath = path;
        _errorMessage = '';
        // Store recording path with current prompt index
        _promptRecordings[currentPromptIndex] = path!;
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
          _errorMessage = '';
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

    Future<void> _uploadRecording() async {
    try {
      setState(() {
        _errorMessage = '';
      });

      if (_audioPath == null) {
        setState(() {
          _errorMessage = '';
        });
        return;
      }

      final String? token = await _secureStorage.read(key: 'accessToken');
      if (token == null) {
        setState(() {
          _errorMessage = 'Not authenticated';
        });
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

        // Create multipart request
        final url = Uri.parse('https://akan-recorder-backend-y5er.onrender.com/recording/')
            .replace(queryParameters: {'text_id': prompts[currentPromptIndex]['id'].toString()});

        // Create multipart request
        var request = http.MultipartRequest('POST', url);

        // Add authorization header
        request.headers.addAll({
          'Authorization': 'Bearer $token',
        });

        // Add the audio file with unique filename
        final file = File(_audioPath!);
        final fileStream = http.ByteStream(file.openRead());
        final fileLength = await file.length();
        final uniqueId = _generateUniqueId();

        final multipartFile = http.MultipartFile(
          'file', // Match the field name expected by the backend
          fileStream,
          fileLength,
          filename: '$uniqueId.wav',
        );

        request.files.add(multipartFile);

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Success - move to next prompt or finish
        if (currentPromptIndex < prompts.length - 1) {
          setState(() {
            currentPromptIndex++;
            _audioPath = null;
          });
        } else {
          Navigator.pushNamed(context, "/home");
        }
      } else if (response.statusCode == 401) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        setState(() {
          _errorMessage = 'Failed to upload recording: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error uploading recording: $e';
      });
    }
  }


  Future<void> _uploadAllRecordings() async {
    try {
      setState(() {
        _isSubmitting = true;
        _errorMessage = '';
      });

      final String? token = await _secureStorage.read(key: 'accessToken');
      if (token == null) {
        setState(() {
          _errorMessage = 'Not authenticated';
          _isSubmitting = false;
        });
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      // Upload each recording
      for (var entry in _promptRecordings.entries) {
        final promptIndex = entry.key;
        final audioPath = entry.value;
        final promptId = prompts[promptIndex]['id'].toString();

        final url = Uri.parse('https://akan-recorder-backend-y5er.onrender.com/recording/')
            .replace(queryParameters: {'text_id': promptId});

        var request = http.MultipartRequest('POST', url);
        request.headers.addAll({
          'Authorization': 'Bearer $token',
        });

        final file = File(audioPath);
        final fileStream = http.ByteStream(file.openRead());
        final fileLength = await file.length();
        final uniqueId = _generateUniqueId();

        final multipartFile = http.MultipartFile(
          'file',
          fileStream,
          fileLength,
          filename: '$uniqueId.wav',
        );

        request.files.add(multipartFile);

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode != 201 && response.statusCode != 200) {
          throw Exception('Failed to upload recording ${promptIndex + 1}: ${response.body}');
        }
      }

      // All uploads successful, navigate to home
      if (mounted) {
        Navigator.pushNamed(context, "/home");
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error uploading recordings: $e';
        _isSubmitting = false;
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
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushNamed(context, "/home"),
        ),
        title: const Text(
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
              style: const TextStyle(color: Colors.black, fontSize: 16),
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
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 4,
                    decoration: BoxDecoration(
                      color: index <= currentPromptIndex
                          ? Colors.black
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (prompts.isNotEmpty)
              Column(
                children: [
                  Text(
                    prompts[currentPromptIndex]['title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    prompts[currentPromptIndex]['english'],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 24),
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
                        icon: const Icon(Icons.play_arrow),
                        onPressed: _playAudio,
                      ),
                  ],
                ),
              ),
            ),
            if (_isSubmitting)
                    const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),

                  // Show error message if any
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    size: 32,
                    color: _audioPath != null
                        ? Colors.grey[700]
                        : Colors.grey[300],
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
                    color: _audioPath != null && !_isRecording
                        ? Colors.grey[700]
                        : Colors.grey[300], // Disable button when recording
                  ),
                  onPressed: _audioPath != null && !_isRecording
                      ? () async {
                          if (currentPromptIndex < prompts.length - 1) {
                            // Move to next prompt without uploading
                            setState(() {
                              currentPromptIndex++;
                              _audioPath = null;
                            });
                          } else {
                            // On last prompt, upload all recordings
                            await _uploadAllRecordings();
                          }
                        }
                      : null, // Disable action when recording
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
