abstract class OtpVerificationState {}

class OtpVerificationStateData extends OtpVerificationState {
  OtpVerificationStateData({
    this.secondsLeft = 60,
    this.isResending = false,
    this.isVerifying = false,
  });

  final int secondsLeft;
  final bool isResending;
  final bool isVerifying;

  bool get canResend => secondsLeft <= 0 && !isResending;

  OtpVerificationStateData copyWith({
    int? secondsLeft,
    bool? isResending,
    bool? isVerifying,
  }) {
    return OtpVerificationStateData(
      secondsLeft: secondsLeft ?? this.secondsLeft,
      isResending: isResending ?? this.isResending,
      isVerifying: isVerifying ?? this.isVerifying,
    );
  }
}