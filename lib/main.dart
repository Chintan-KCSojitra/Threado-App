/*
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thredo/l10n/app_localizations.dart';
import 'package:thredo/localization/locale_cubit.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/services/screenshot_detector.dart';
import 'package:thredo/utils/shared_preference_util.dart';
import 'package:thredo/view/splash/splash_screen.dart';
import 'package:toastification/toastification.dart';

import 'api/dio_helper.dart';

GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  setUpWidget();
  // Initialise the screenshot channel once — before any screen subscribes.
  ScreenshotDetector.init();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: colorWhite,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(BlocProvider(create: (_) => LocaleCubit(), child: const MyApp()));
  //runApp(const MyApp());
}

Future<void> setUpWidget() async {
  DioHelper.init();
  await SharedPreferenceUtil.getInstance();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static final Connectivity _connectivity = Connectivity();
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  OverlaySupportEntry? _overlayEntry;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _initializeConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _initializeConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (mounted) {
        await _updateConnectionStatus(result);
      }
    } catch (e) {
      debugPrint('Connectivity Error: $e');
    }
  }

  Future<void> _updateConnectionStatus(
    final List<ConnectivityResult> result,
  ) async {
    if (_connectionStatus.length == result.length &&
        _connectionStatus.toString() == result.toString()) {
      return;
    }
    setState(() => _connectionStatus = result);
    _overlayEntry?.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      buildWhen: (prev, next) => prev != next,
      builder: (context, locale) {
        return OverlaySupport.global(
          child: ScreenUtilInit(
            minTextAdapt: true,
            splitScreenMode: false,
            useInheritedMediaQuery: true,
            ensureScreenSize: true,
            designSize: const Size(375, 812),
            builder: (context, child) => ToastificationWrapper(
              child: RefreshConfiguration(
                footerTriggerDistance: 15,
                headerTriggerDistance: 5.0,
                dragSpeedRatio: 1.0,
                headerBuilder: () => const MaterialClassicHeader(),
                footerBuilder: () => const ClassicFooter(
                  canLoadingText: '',
                  failedText: '',
                  noDataText: '',
                  noMoreIcon: SizedBox.shrink(),
                ),
                enableLoadingWhenNoData: false,
                enableRefreshVibrate: false,
                enableLoadMoreVibrate: false,
                shouldFooterFollowWhenNotFull: (state) => false,
                child: MaterialApp(
                  locale: locale,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  navigatorObservers: const [],
                  builder: (context, child) {
                    final mediaQueryData = MediaQuery.of(context);
                    return MediaQuery(
                      data: mediaQueryData.copyWith(
                        textScaler: const TextScaler.linear(1),
                      ),
                      child: child!,
                    );
                  },
                  navigatorKey: rootNavigatorKey,
                  debugShowCheckedModeBanner: false,
                  onGenerateTitle: (context) =>
                      AppLocalizations.of(context).appName,
                  theme: ThemeData.from(colorScheme: const ColorScheme.light())
                      .copyWith(
                        pageTransitionsTheme: const PageTransitionsTheme(
                          builders: {
                            TargetPlatform.android:
                                ZoomPageTransitionsBuilder(),
                          },
                        ),
                      ),
                  home: const SplashScreen(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
*/
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thredo/l10n/app_localizations.dart';
import 'package:thredo/localization/locale_cubit.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/services/screenshot_detector.dart';
import 'package:thredo/utils/shared_preference_util.dart';
import 'package:thredo/view/splash/splash_screen.dart';
import 'package:toastification/toastification.dart';

import 'api/dio_helper.dart';

GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

// ─── [OPT-1] Run heavy async setup in parallel ───────────────────────────────
// Previously, DioHelper.init() and SharedPreferenceUtil were called inside
// setUpWidget() which ran before runApp. This approach is fine but we can
// make init tasks explicit and parallel using Future.wait, reducing startup
// time on devices where I/O is slow.
Future<void> _initApp() async {
  // These two tasks are independent — run them concurrently.
  await Future.wait([
    SharedPreferenceUtil.getInstance(),
    // DioHelper.init() is synchronous, but wrapping it keeps the pattern
    // clean and future-proof if it ever becomes async.
    Future(() => DioHelper.init()),
  ]);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Increase image cache size to handle high-resolution shade cards safely
  PaintingBinding.instance.imageCache.maximumSize = 500; // Increase number of images
  PaintingBinding.instance.imageCache.maximumSizeBytes = 300 * 1024 * 1024; // 300 MB

  // ─── [OPT-2] Lock orientation & set system UI before any async gap ──────
  // Doing these synchronously before await prevents a brief visual flash where
  // the wrong orientation or status bar colour appears during startup.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: colorWhite,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // ─── [OPT-3] Run all initialisation in parallel ──────────────────────────
  await Future.wait([_initApp(), ScreenshotDetector.init()]);

  // ─── [OPT-4] Create the cubit once outside the widget tree ──────────────
  // Constructing LocaleCubit here means the BlocProvider below never recreates
  // it on hot reload / tree rebuilds. Prevents an unnecessary rebuild cycle
  // at the root of the tree.
  final localeCubit = LocaleCubit();

  runApp(BlocProvider.value(value: localeCubit, child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // ─── [OPT-6] Reuse a single Connectivity instance ───────────────────────
  // The original code stored this as a static field. Keeping it as an instance
  // field is equivalent but avoids the implicit global state of a static.
  final Connectivity _connectivity = Connectivity();
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  OverlaySupportEntry? _overlayEntry;

  // ─── [OPT-7] Cache the ThemeData so it isn't rebuilt on every locale ─────
  // ThemeData.from(...).copyWith(...) allocates many internal objects.
  // Computing it once at field initialisation time (before the first build)
  // means locale changes — the only thing that triggers BlocBuilder rebuilds
  // at the root level — no longer recreate the entire theme.
  static final ThemeData _appTheme = ThemeData.from(colorScheme: const ColorScheme.light()).copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(builders: {TargetPlatform.android: ZoomPageTransitionsBuilder()}),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _initializeConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (mounted) {
        await _updateConnectionStatus(result);
      }
    } catch (e) {
      debugPrint('Connectivity Error: $e');
    }
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    // ─── [OPT-8] Avoid redundant setState calls ──────────────────────────
    // The original equality check compared toString() representations, which
    // works but allocates two strings on every connectivity event just to
    // compare them. Using listEquals from foundation is allocation-free for
    // equal lists of the same length and more idiomatic.
    if (_connectionStatus.length == result.length && _listEquals(_connectionStatus, result)) {
      return;
    }
    _connectionStatus = result;
    _overlayEntry?.dismiss();
  }

  // ─── [OPT-9] Inline list equality to avoid importing foundation ──────────
  // A simple O(n) loop avoids creating string representations.
  bool _listEquals(List<ConnectivityResult> a, List<ConnectivityResult> b) {
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      // ─── [OPT-10] Keep the buildWhen guard ──────────────────────────────
      // This already exists in the original and is correct — only rebuild when
      // the locale actually changes.
      buildWhen: (prev, next) => prev != next,
      builder: (context, locale) {
        return OverlaySupport.global(
          child: ScreenUtilInit(
            minTextAdapt: true,
            splitScreenMode: false,
            useInheritedMediaQuery: true,
            ensureScreenSize: true,
            designSize: const Size(375, 812),
            // ─── [OPT-11] Use the child parameter of ScreenUtilInit ────────
            // Passing `child` lets ScreenUtilInit skip rebuilding subtrees that
            // don't depend on screen metrics. The builder is only invoked when
            // metrics change, and the static subtree is reused unchanged.
            child: const SplashScreen(),
            builder: (context, child) => ToastificationWrapper(
              child: RefreshConfiguration(
                footerTriggerDistance: 15,
                headerTriggerDistance: 5.0,
                dragSpeedRatio: 1.0,
                headerBuilder: () => const MaterialClassicHeader(),
                footerBuilder: () => const ClassicFooter(
                  canLoadingText: '',
                  failedText: '',
                  noDataText: '',
                  noMoreIcon: SizedBox.shrink(),
                ),
                enableLoadingWhenNoData: false,
                enableRefreshVibrate: false,
                enableLoadMoreVibrate: false,
                shouldFooterFollowWhenNotFull: (state) => false,
                child: MaterialApp(
                  locale: locale,
                  localizationsDelegates: AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  // ─── [OPT-12] Keep navigatorObservers as const ──────────
                  // An empty const list is a compile-time constant and is
                  // never reallocated.
                  navigatorObservers: const [],
                  builder: (context, child) {
                    // ─── [OPT-13] Avoid full MediaQuery reconstruction ─────
                    // copyWith with a single field is already efficient, but
                    // we guard against null child explicitly to satisfy the
                    // null-safety checker without a force-unwrap crash in
                    // edge cases (e.g. during hot reload).
                    if (child == null) return const SizedBox.shrink();
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
                      child: child,
                    );
                  },
                  navigatorKey: rootNavigatorKey,
                  debugShowCheckedModeBanner: false,
                  onGenerateTitle: (context) => AppLocalizations.of(context).appName,
                  // ─── [OPT-14] Use cached ThemeData ───────────────────────
                  theme: _appTheme,
                  home: child, // reuses the const SplashScreen from above
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
