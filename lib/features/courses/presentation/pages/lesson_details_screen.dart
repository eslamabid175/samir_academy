import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samir_academy/features/auth/presentation/bloc/auth_bloc.dart'; // Import AuthBloc
import 'package:samir_academy/features/courses/presentation/bloc/course_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonDetailsScreen extends StatefulWidget {
  final String courseId;
  final String unitId;
  final String lessonId;
  final String lessonTitle; // Passed for AppBar title initially

  const LessonDetailsScreen({
    Key? key,
    required this.courseId,
    required this.unitId,
    required this.lessonId,
    required this.lessonTitle,
  }) : super(key: key);

  @override
  State<LessonDetailsScreen> createState() => _LessonDetailsScreenState();
}

class _LessonDetailsScreenState extends State<LessonDetailsScreen> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    // Load lesson details only if not already loaded for this lesson
    final state = context.read<CourseBloc>().state;
    bool shouldLoad = true;
    if (state is LessonDetailsLoaded && state.lesson.id == widget.lessonId) {
        shouldLoad = false;
    }
    if (shouldLoad) {
      _loadLessonDetails();
    }
  }

  void _loadLessonDetails() {
     BlocProvider.of<CourseBloc>(context).add(
      GetLessonDetailsEvent(
        courseId: widget.courseId,
        unitId: widget.unitId,
        lessonId: widget.lessonId,
      ),
    );
  }

  void _initializePlayer(String videoId) {
    try {
      _controller?.dispose(); // Dispose existing controller first
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: true,
          forceHD: false, // Don't force HD to reduce crashes
          useHybridComposition: true, // Use hybrid composition for better stability
        ),
      )..addListener(_listener);
    } catch (e) {
      print('Error initializing YouTube player: $e');
      // Handle initialization error gracefully
    }
  }

  void _listener() {
    if (mounted && _controller != null && !_controller!.value.isFullScreen) {
      // Handle player state changes if needed
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to edge
    _controller?.pause();
    super.deactivate();
  }


  @override
  void dispose() {
    _controller?.removeListener(_listener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lessonTitle), // Use passed title initially (assuming dynamic)
      ),
      body: BlocConsumer<CourseBloc, CourseState>(
        listener: (context, state) {
          // Initialize player when lesson details are loaded
          if (state is LessonDetailsLoaded && state.lesson.id == widget.lessonId && state.lesson.youtubeVideoId.isNotEmpty) {
             // Dispose existing controller if any before initializing new one
            _controller?.dispose();
            _initializePlayer(state.lesson.youtubeVideoId);
          }
        },
        builder: (context, state) {
          if (state is LessonDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LessonDetailsLoaded && state.lesson.id == widget.lessonId) {
            final lesson = state.lesson;

            // Ensure player is initialized if not already (e.g., state change after init)
            if (_controller == null && lesson.youtubeVideoId.isNotEmpty) {
               _initializePlayer(lesson.youtubeVideoId);
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lesson Title (can use state.lesson.title for updated title)
                  Text(
                    lesson.title, // Assuming title is dynamic
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  
                  // YouTube Player
                  if (_controller != null)
                    YoutubePlayer(
                      controller: _controller!,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.amber,
                      progressColors: const ProgressBarColors(
                        playedColor: Colors.amber,
                        handleColor: Colors.amberAccent,
                      ),
                      onReady: () {
                        print('Player is ready.');
                      },
                      onEnded: (YoutubeMetaData _) {
                        // Handle video end
                      },
                      topActions: [], // Minimize top actions to reduce UI complexity
                      bottomActions: [
                        CurrentPosition(),
                         ProgressBar(isExpanded: true),
                         RemainingDuration(),
                         PlaybackSpeedButton(),
                      ],
                    )
                  else if (lesson.youtubeVideoId.isEmpty)
                     Text('no_video_associated'.tr())
                  else // Still loading controller or error
                     const Center(child: CircularProgressIndicator()),

                  const SizedBox(height: 16.0),
                  // Lesson Description
                  Text(
                    lesson.description, // Assuming description is dynamic
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          } else if (state is CourseError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('error_loading_lesson_details'.tr(args: [state.message]), textAlign: TextAlign.center),
              ),
            );
          } else {
            // Initial state or unexpected state
            // Trigger loading if state is not relevant
            if (state is! LessonDetailsLoading) _loadLessonDetails();
            return Center(child: Text('loading_lesson_details'.tr()));
          }
        },
      ),
      // No FAB needed here based on original code
    );
  }
}

