import 'package:flutter/material.dart';
import 'package:flutter_story_presenter/flutter_story_presenter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FlutterStoryPresenter(
        restartOnCompleted: false,
        flutterStoryController: FlutterStoryController(),
        storyViewIndicatorConfig: StoryViewIndicatorConfig(
          activeColor: Colors.red,
        ),
        items: [
          StoryItem(
            url:
                'https://www.sample-videos.com/video321/mp4/480/big_buck_bunny_480p_10mb.mp4',
            storyItemType: StoryItemType.video,
            storyItemSource: StoryItemSource.network,
            videoConfig: StoryViewVideoConfig(
              cacheVideo: true,
              useVideoAspectRatio: false,
            ),
          ),
        ],
      ),
    );
  }
}
