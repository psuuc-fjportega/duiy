import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final List<Map<String, dynamic>> songs;
  late final AudioPlayer player;
  int? playingIndex;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          playingIndex = null;
          for (var song in songs) {
            song['isPlaying'] = false;
          }
        });
      }
    });

    songs = [
      {
        'title': 'Rapstar',
        'singer': 'Flow G',
        'songAssets': 'assets/audios/rapstar.mp3',
        'cover': 'assets/images/flowg.jpg',
        'isPlaying': false,
      },
      {
        'title': 'Yugyugan Na',
        'singer': 'KZ Tandingan',
        'songAssets': 'assets/audios/yugyugan.mp3',
        'cover': 'assets/images/kz.jpg',
        'isPlaying': false,
      },
      {
        'title': 'Toss A Coin',
        'singer': 'NF',
        'songAssets': 'assets/audios/toss.mp3',
        'cover': 'assets/images/witcher.jpg',
        'isPlaying': false,
      },
      {
        'title': 'Heavy Is The Crown',
        'singer': 'Daughtry',
        'songAssets': 'assets/audios/heavyisthecrown.mp3',
        'cover': 'assets/images/daughtry.jpg',
        'isPlaying': false,
      },
      {
        'title': 'Probinsyana',
        'singer': 'Bamboo',
        'songAssets': 'assets/audios/probinsyana.mp3',
        'cover': 'assets/images/bamboo.jpg',
        'isPlaying': false,
      },
      {
        'title': "It's Gonna Be Me",
        'singer': 'Nu.G',
        'songAssets': 'assets/audios/nug.mp3',
        'cover': 'assets/images/nug.jpg',
        'isPlaying': false,
      },
    ];
  }

  Future<void> _togglePlayPause(int index) async {
    try {
      if (playingIndex == index) {
        if (player.playing) {
          await player.pause();
        } else {
          await player.play();
        }
        setState(() {
          songs[index]['isPlaying'] = player.playing;
        });
      } else {
        if (playingIndex != null) {
          songs[playingIndex!]['isPlaying'] = false;
        }
        setState(() {
          playingIndex = index;
          songs[index]['isPlaying'] = true;
        });
        await player.stop();
        await player.setAsset(songs[index]['songAssets']);
        await player.play();
      }
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            '🎵 My Favorite Songs',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.deepPurple.shade800,
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.deepPurple.shade900, Colors.black],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.deepPurple.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 8,
                  shadowColor: Colors.purpleAccent,
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                          songs[index]['cover'] != null
                              ? Image.asset(
                                songs[index]['cover'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                              : Image.asset(
                                'assets/images/default_cover.jpg', // Add a default image
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                    ),

                    title: Text(
                      songs[index]['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      songs[index]['singer'],
                      style: TextStyle(color: Colors.white70),
                    ),
                    trailing: IconButton(
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (child, animation) =>
                                ScaleTransition(scale: animation, child: child),
                        child: Icon(
                          songs[index]['isPlaying']
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          key: ValueKey<bool>(songs[index]['isPlaying']),
                          size: 50,
                          color:
                              songs[index]['isPlaying']
                                  ? Colors.greenAccent
                                  : Colors.blueAccent,
                        ),
                      ),
                      onPressed: () => _togglePlayPause(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
