import '../../domain/entities/user.dart';

/// Data-layer mirror of [User] with JSON (de)serialization; kept as a plain hand-written model (not freezed/json_serializable) to avoid depending on the "any"-pinned codegen packages (pubspec.yaml Remaining Issues) for a shape this simple.
final class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.displayName,
    super.avatarId,
    super.bio,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        username: json['username'] as String,
        email: json['email'] as String,
        displayName:
            json['displayName'] as String? ?? json['username'] as String,
        avatarId: json['avatarId'] as String?,
        bio: json['bio'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'displayName': displayName,
        'avatarId': avatarId,
        'bio': bio,
      };
}

/// Login/register response shape: `{ user, accessToken, refreshToken }` (PLAN.md section 16).
final class AuthResponseModel {
  const AuthResponseModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      AuthResponseModel(
        user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
      );

  final UserModel user;
  final String accessToken;
  final String refreshToken;
}
