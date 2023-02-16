import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../constants/mocks/videos.dart';
import 'video_view_state.dart';

final videoControllerProvider =
    StateNotifierProvider.autoDispose<VideoViewController, VideoViewState>(
        (ref) {
  return VideoViewController();
});

class VideoViewController extends StateNotifier<VideoViewState> {
  VideoViewController() : super(const VideoViewState());

  Timer? timer;

  void onInitComplete(VideoPlayerController controller) {
    state = state.copyWith(
      isInitialized: true,
      status: const AsyncData(null),
    );
    controller.setLooping(false);
    getVideoLength(controller.value.duration);
    _play(controller);
  }

  void onVideoForward(VideoPlayerController controller) async {
    final current = controller.value.position;
    final position = current + kJumpValue;
    _seekTo(controller, position);
    if (state.isPlaying) {
      _play(controller);
    }
    autoHideController();
  }

  void onVideoBackward(VideoPlayerController controller) async {
    final current = controller.value.position;
    final position = current - kJumpValue;
    _seekTo(controller, position);
    if (state.isPlaying) {
      _play(controller);
    }
    autoHideController();
  }

  void onPlayPressed(VideoPlayerController controller) {
    _play(controller);
    hideController();
  }

  void onPausePressed(VideoPlayerController controller) {
    _pause(controller);
    autoHideController();
  }

  void showController() {
    state = state.copyWith(showController: true);
    autoHideController();
  }

  void hideController() {
    state = state.copyWith(showController: false);
  }

  void updateOnPlaying({required Duration position}) {
    state = state.copyWith(position: position);
  }

  void getVideoLength(Duration duration) {
    state = state.copyWith(duration: duration);
  }

  void autoHideController() {
    timer?.cancel();
    timer = Timer(kAutoHideValue, hideController);
  }

  void onHorizontalDragStart(VideoPlayerController controller) {
    state = state.copyWith(status: const AsyncLoading());
    timer?.cancel();
    _pause(controller);
  }

  void onHorizontalDragUpdate(
      VideoPlayerController controller, double relativePosition) {
    final position = controller.value.duration * relativePosition;
    _seekTo(controller, position);
  }

  void onHorizontalDragEnd(VideoPlayerController controller) {
    _play(controller);
    autoHideController();
  }

  void onTapDown(VideoPlayerController controller, double relativePosition) {
    state = state.copyWith(status: const AsyncLoading());
    final position = controller.value.duration * relativePosition;
    _seekTo(controller, position);
    onHorizontalDragEnd(controller);
  }

  void _seekTo(VideoPlayerController controller, Duration position) async {
    final async = await AsyncValue.guard(() => controller.seekTo(position));
    state = state.copyWith(status: async);
  }

  void _play(VideoPlayerController controller) async {
    final async = await AsyncValue.guard(() => controller.play());
    state = state.copyWith(
      isPlaying: async.hasError ? state.isPlaying : true,
      status: async,
    );
  }

  void _pause(VideoPlayerController controller) async {
    final async = await AsyncValue.guard(() => controller.pause());
    state = state.copyWith(
      isPlaying: async.hasError ? state.isPlaying : false,
      status: async,
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}