import 'package:equatable/equatable.dart';

/// The signed-in resident of Qaa El Hamour; a pure Domain entity — no JSON/Dio knowledge (that's [UserModel]'s job in the Data layer).
final class User extends Equatable {
  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.displayName,
    this.avatarId,
    this.bio,
  });

  final String id;
  final String username;
  final String email;
  final String displayName;
  final String? avatarId;
  final String? bio;

  @override
  List<Object?> get props => [id, username, email, displayName, avatarId, bio];
}
