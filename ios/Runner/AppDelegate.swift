import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {

  private let channelName = "screenshot_detector"
  private var eventSink: FlutterEventSink?
  private var eventChannel: FlutterEventChannel?
  private var channelConfigured = false

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let result = super.application(
      application,
      didFinishLaunchingWithOptions: launchOptions
    )

    configureScreenshotChannel()
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(screenshotTaken),
      name: UIApplication.userDidTakeScreenshotNotification,
      object: nil
    )

    return result
  }

  private func configureScreenshotChannel() {
    guard !channelConfigured else { return }

    guard let controller = window?.rootViewController as? FlutterViewController else {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
        self?.configureScreenshotChannel()
      }
      return
    }

    let channel = FlutterEventChannel(
      name: channelName,
      binaryMessenger: controller.binaryMessenger
    )
    channel.setStreamHandler(self)
    eventChannel = channel
    channelConfigured = true
  }

  @objc private func screenshotTaken() {
    DispatchQueue.main.async { [weak self] in
      self?.eventSink?("iOS Screenshot Captured")
    }
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

extension AppDelegate: FlutterStreamHandler {
  func onListen(
    withArguments arguments: Any?,
    eventSink events: @escaping FlutterEventSink
  ) -> FlutterError? {
    eventSink = events
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }
}
