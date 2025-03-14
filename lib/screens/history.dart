import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<RecordingWithText> recordings = [];
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchRecordingsAndTexts();
  }

  Future<String?> _getToken() async {
    final String? token = await _secureStorage.read(key: 'accessToken');
    return token;
  }

  Future<TextItem?> fetchText(int textId, String token) async {
  try {
    final response = await http.get(
      Uri.parse('https://akan-recorder-backend-y5er.onrender.com/texts/$textId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return TextItem.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      print('Failed to fetch text $textId: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching text $textId: $e');
  }
  return null;
}

Future<void> fetchRecordingsAndTexts() async {
  try {
    final token = await _getToken();
    if (token == null) {
      if (mounted) {
        setState(() {
          error = 'Not authenticated';
          isLoading = false;
        });
      }
      return;
    }

    final response = await http.get(
      Uri.parse('https://akan-asr-backend-d5ee511bc4b5.herokuapp.com/recording/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<RecordingWithText> recordingsWithText = [];

      // Fetch texts concurrently for all recordings
      final List<Future<TextItem?>> textRequests = data.map((recordingData) {
        final recording = RecordingItem.fromJson(recordingData);
        return fetchText(recording.textId, token);
      }).toList();

      // Wait for all text requests to complete
      final List<TextItem?> texts = await Future.wait(textRequests);

      // Add recordings with texts
      for (int i = 0; i < data.length; i++) {
        final recording = RecordingItem.fromJson(data[i]);
        final text = texts[i];
        if (text != null) {
          recordingsWithText.add(RecordingWithText(recording: recording, text: text));
        }
      }

      if (mounted) {
        setState(() {
          recordings = recordingsWithText;
          isLoading = false;
        });
      }
    } else if (response.statusCode == 401) {
      if (mounted) {
        setState(() {
          error = 'Session expired. Please login again';
          isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          error = 'Failed to load recordings';
          isLoading = false;
        });
      }
    }
  } catch (e) {
    if (mounted) {
      setState(() {
        error = 'Network error: Please check your internet connection.';
        isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Recording History",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ))
          : error != null
              ? Center(child: Text(error!))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: recordings.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = recordings[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      title: Text(
                        item.text.content,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.text.translation,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

class RecordingItem {
  final String audioUrl;
  final int duration;
  final int id;
  final String userId;
  final int textId;
  final String createdAt;

  RecordingItem({
    required this.audioUrl,
    required this.duration,
    required this.id,
    required this.userId,
    required this.textId,
    required this.createdAt,
  });

  factory RecordingItem.fromJson(Map<String, dynamic> json) {
    return RecordingItem(
      audioUrl: json['audio_url'] ?? '',
      duration: json['duration'] ?? 0,
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? '',
      textId: json['text_id'] ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }
}

class TextItem {
  final String content;
  final String translation;

  TextItem({
    required this.content,
    required this.translation,
  });

  factory TextItem.fromJson(Map<String, dynamic> json) {
    return TextItem(
      content: json['content'] ?? '',
      translation: json['translation'] ?? '',
    );
  }
}

class RecordingWithText {
  final RecordingItem recording;
  final TextItem text;

  RecordingWithText({
    required this.recording,
    required this.text,
  });
}
