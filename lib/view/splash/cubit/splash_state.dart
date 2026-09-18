abstract class SplashState {}

class SplashInitialState extends SplashState {}

class SplashImageLoadedState extends SplashState {
  SplashImageLoadedState({required this.imageUrls});

  final List<String> imageUrls;
}

class SplashImageErrorState extends SplashState {}
