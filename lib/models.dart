enum JoyRole { owner, admin, moderator, creator, user }

class JoyUser {
  final String id;
  final String name;
  final String handle;
  final JoyRole role;
  final int coins;
  final bool verified;
  final bool joyPlus;
  final bool unlimitedCoins;
  final int followers;

  const JoyUser({
    required this.id,
    required this.name,
    required this.handle,
    required this.role,
    required this.coins,
    required this.verified,
    required this.joyPlus,
    required this.unlimitedCoins,
    required this.followers,
  });

  JoyUser copyWith({
    JoyRole? role,
    int? coins,
    bool? verified,
    bool? joyPlus,
    bool? unlimitedCoins,
  }) => JoyUser(
    id: id, name: name, handle: handle,
    role: role ?? this.role, coins: coins ?? this.coins,
    verified: verified ?? this.verified, joyPlus: joyPlus ?? this.joyPlus,
    unlimitedCoins: unlimitedCoins ?? this.unlimitedCoins,
    followers: followers,
  );
}

class JoyPost {
  final String author;
  final String caption;
  final String mediaLabel;
  final int likes;
  final int comments;
  final int shares;
  final String mood;

  const JoyPost({required this.author, required this.caption, required this.mediaLabel, required this.likes, required this.comments, required this.shares, required this.mood});
}


class JoyStatus {
  final String authorId;
  final String author;
  final String label;
  final bool video;
  final bool viewed;
  final int viewers;
  final DateTime createdAt;

  const JoyStatus({
    required this.authorId, required this.author, required this.label,
    required this.video, required this.viewed, required this.viewers, required this.createdAt,
  });

  bool get isExpired => DateTime.now().difference(createdAt).inHours >= 24;
}
