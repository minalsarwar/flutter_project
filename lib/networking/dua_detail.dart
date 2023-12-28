import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/networking/app_state.dart';
import 'package:flutter_application_1/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final String title;
  final String id;
  final String arabic;
  final String transliteration;
  final String translation;
  final String source;
  final int count;
  final String explanation;

  const DetailScreen(
      {required this.title,
      required this.id,
      required this.arabic,
      required this.transliteration,
      required this.translation,
      required this.source,
      required this.count,
      required this.explanation});

  DetailScreen.fromSnapshot(DocumentSnapshot snapshot)
      : title = snapshot['title'],
        id = snapshot.id, // Use the document ID directly
        arabic = snapshot['arabic'],
        transliteration = snapshot['transliteration'],
        translation = snapshot['translation'],
        source = snapshot['source'],
        count = snapshot['count'],
        explanation = snapshot['explanation'];

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  late String arabic;
  late String transliteration;
  late String translation;
  late String source;
  late int count;
  late String explanation;
  int _currentIndex = 0;
  late int originalCount;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    arabic = widget.arabic;
    transliteration = widget.transliteration;
    translation = widget.translation;
    source = widget.source;
    count = widget.count;
    originalCount = count;
    explanation = widget.explanation;

    final audioPlayer = ref.read(audioPlayerProvider);
    audioPlayer.positionStream.listen((position) {
      // No need for setState here; the UI will be automatically updated
    });

    AuthService().getUserId().then((userId) async {
      if (userId != null) {
        String duaId = widget.id;
        // Check if the dua is already a favorite
        bool isAlreadyFavorite = await isDuaFavorite(userId, duaId);

        setState(() {
          isFavorite = isAlreadyFavorite;
        });
      }
    });
  }

  Future<void> toggleFavoriteStatus() async {
    String? userId = await AuthService().getUserId();
    if (userId != null) {
      String duaId = widget.id;

      // Check if the dua is already a favorite
      bool isAlreadyFavorite = await isDuaFavorite(userId, duaId);

      // Toggle the favorite status
      if (isAlreadyFavorite) {
        removeFromFavorites(userId, duaId);
      } else {
        addToFavorites(userId, duaId);
      }

      // Update the UI
      setState(() {
        isFavorite = !isAlreadyFavorite;
      });
    }
  }

  Future<bool> isDuaFavorite(String userId, String duaId) async {
    // Check if the dua is in the user's favorites collection
    QuerySnapshot favoritesSnapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .where('user_id', isEqualTo: userId)
        .where('dua_id', isEqualTo: duaId)
        .get();

    return favoritesSnapshot.docs.isNotEmpty;
  }

  Future<void> addToFavorites(String userId, String duaId) async {
    // Add the dua to the user's favorites collection
    await FirebaseFirestore.instance.collection('favorites').add({
      'user_id': userId,
      'dua_id': duaId,
    });
  }

  Future<void> removeFromFavorites(String userId, String duaId) async {
    // Remove the dua from the user's favorites collection
    QuerySnapshot favoritesSnapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .where('user_id', isEqualTo: userId)
        .where('dua_id', isEqualTo: duaId)
        .get();

    if (favoritesSnapshot.docs.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('favorites')
          .doc(favoritesSnapshot.docs.first.id)
          .delete();
    }
  }

  // }
  Future<void> _playAudio() async {
    try {
      String audioUrl = await _getAudioUrl(widget.id);

      await _audioPlayer.setUrl(audioUrl);

      if (_audioPlayer.playing) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play();
      }
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<String> _getAudioUrl(String duaId) async {
    try {
      QuerySnapshot audioSnapshot = await FirebaseFirestore.instance
          .collection('audios')
          .where('dua_id', isEqualTo: duaId)
          .get();
      print(duaId);

      if (audioSnapshot.docs.isNotEmpty) {
        return audioSnapshot.docs.first['audio'];
      } else {
        throw StateError("No document found with dua_id: $duaId");
      }
    } catch (e) {
      print("Error fetching audio URL: $e");
      throw e;
    }
  }

  Widget mediaPlayerDesign(WidgetRef ref) {
    final audioPositionData = ref.watch(audioPositionProvider);
    final isPlaying = ref.read(audioStateProvider).isPlaying;
    final position = audioPositionData?.value ?? Duration.zero;
    final duration = ref.read(audioStateProvider).duration;

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 40.0,
                ),
                onPressed: () {
                  ref.read(audioStateProvider.notifier).playPause();
                },
              ),
            ],
          ),
          Column(
            children: [
              Slider(
                value: position.inMilliseconds.toDouble(),
                onChanged: (value) {
                  ref
                      .read(audioStateProvider.notifier)
                      .seekTo(Duration(milliseconds: value.toInt()));
                },
                min: 0.0,
                max: duration.inMilliseconds.toDouble(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDuration(position),
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      formatDuration(duration),
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.restart_alt),
                onPressed: () {
                  ref.read(audioStateProvider.notifier).seekTo(Duration.zero);
                },
              ),
              IconButton(
                icon: Icon(Icons.speed),
                onPressed: () {
                  // Handle playback speed functionality here
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.title,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: CustomColors.mainColor,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                arabic,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.end,
              ),
              SizedBox(height: 20),
              Text(
                transliteration,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 20),
              Text(
                translation,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.bubble_chart_rounded, color: Colors.grey),
                  SizedBox(width: 2),
                  Text(
                    'Source',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Text(
                source,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    // Play audio when the bottom sheet is displayed
                    _playAudio();
                    return mediaPlayerDesign(ref);
                  },
                );
              },
              child: Icon(Icons.play_arrow),
            ),
            label: 'Play',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          '${explanation.isNotEmpty ? 'Explanation:\n\n$explanation' : "No explanation available yet"}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Icon(Icons.info),
            ),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                // Handle the counter functionality here
                // For example, you can increment the count variable
                setState(() {
                  if (count > 0) {
                    count -= 1;
                  }
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomColors.mainColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                  child: count > 0
                      ? Text(
                          count.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      : IconButton(
                          icon: Icon(Icons.restart_alt, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              count = originalCount;
                            });
                          },
                        ),
                ),
              ),
            ),
            label: 'Count',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                String title = widget.title;
                Share.share(
                    '$title\n\n$arabic\n\nRepeat ${count == 1 ? "1 time" : "$count times"}\n\n$transliteration\n\n$translation\n\nSource:\n$source');
              },
              child: Icon(Icons.share),
            ),
            label: 'Share',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                toggleFavoriteStatus();
              },
              child: Icon(
                Icons.favorite,
                color: isFavorite ? Colors.red : null,
              ),
            ),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }
}
