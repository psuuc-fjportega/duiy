import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> songs = [
    {
      'title': 'Rapstar',
      'singer': 'Flow G',
      'songAssets': 'assets/audios/rapstar.mp3',
      'cover': 'assets/images/flowg.jpg',
      'isPlaying': false,
    },
    {
      'title': 'Toss a Coin',
      'singer': 'Dan Vasc',
      'songAssets': 'assets/audios/toss.mp3',
      'cover': 'assets/images/witcher.jpg',
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
      'title': 'Yugyugan Na',
      'singer': 'KZ Tandingan',
      'songAssets': 'assets/audios/yugyugan.mp3',
      'cover': 'assets/images/kz.jpg',
      'isPlaying': false,
    },
    {
      'title': "It's Gonna Be Me",
      'singer': 'Nu.G',
      'songAssets': 'assets/audios/nug.mp3',
      'cover': 'assets/images/nug.jpg',
      'isPlaying': false,
    },
    {
      'title': 'Heavy Is The Crown',
      'singer': 'Daughtry',
      'songAssets': 'assets/audios/heavyisthecrown.mp3',
      'cover': 'assets/images/daughtry.jpg',
      'isPlaying': false,
    },
  ];

  late final AudioPlayer player;
  int? playingIndex;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();

    // Listen for changes in playback state
    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed ||
          state.processingState == ProcessingState.idle) {
        setState(() {
          if (playingIndex != null) songs[playingIndex!]['isPlaying'] = false;
          playingIndex = null;
        });
      }
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> toggleSong(int index) async {
    if (index == playingIndex) {
      await player.pause();
      setState(() {
        songs[index]['isPlaying'] = false;
        playingIndex = null;
      });
    } else {
      if (playingIndex != null) {
        songs[playingIndex!]['isPlaying'] = false;
      }

      setState(() {
        playingIndex = index;
        songs[index]['isPlaying'] = true;
      });

      try {
        await player.setAsset(songs[index]['songAssets']);
        await player.play();
      } catch (e) {
        print("Error playing audio: $e");
        setState(() {
          songs[index]['isPlaying'] = false;
          playingIndex = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(229, 221, 197, 1),
      appBar: AppBar(
        title: const Text('My Favorite Songs Playlist'),
        backgroundColor: const Color.fromRGBO(241, 238, 220, 1),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            return Card(
              color: const Color.fromRGBO(241, 238, 220, 1),
              child: ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    songs[index]['isPlaying']
                        ? const Icon(Icons.equalizer)
                        : Text(
                          '0${index + 1}',
                          style: const TextStyle(fontSize: 12),
                        ),
                    const SizedBox(width: 8),
                    Image.asset(
                      songs[index]['cover'],
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.music_note, size: 50);
                      },
                    ),
                  ],
                ),
                title: Text(songs[index]['title']),
                subtitle: Text(songs[index]['singer']),
                trailing: IconButton(
                  onPressed: () => toggleSong(index),
                  icon: Icon(
                    songs[index]['isPlaying'] ? Icons.pause : Icons.play_arrow,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
