import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_state.freezed.dart';

@freezed
class SignUpState with _$SignUpState {
  const factory SignUpState.initial() = _Initial;
  const factory SignUpState.unauthenticated() = _Unauthenticated;
  const factory SignUpState.authenticated(String userId) = _Authenticated;
  const factory SignUpState.loading() = _Loading;
  const factory SignUpState.error(String message) = _Error;
}