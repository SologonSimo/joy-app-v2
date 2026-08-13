import 'models.dart';

/// Prototype authority layer. In production this logic MUST run on the backend
/// inside an atomic transaction; the client must not be trusted for privileges.
class JoyAuthService {
  final List<JoyUser> _users = [];

  JoyUser register(String name, String handle) {
    final isFirst = _users.isEmpty;
    final user = JoyUser(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      handle: handle,
      role: isFirst ? JoyRole.owner : JoyRole.user,
      coins: 0,
      verified: isFirst,
      joyPlus: isFirst,
      unlimitedCoins: isFirst,
      followers: 0,
    );
    _users.add(user);
    return user;
  }

  bool isOwner(JoyUser user) => user.role == JoyRole.owner;
  bool canManageRoles(JoyUser actor) => isOwner(actor);
  bool canManageCoins(JoyUser actor) => isOwner(actor);
  bool canGrantJoyPlus(JoyUser actor) => isOwner(actor);
  bool canModerate(JoyUser actor) => isOwner(actor) || actor.role == JoyRole.admin || actor.role == JoyRole.moderator;

  JoyUser grantJoyPlus({required JoyUser actor, required JoyUser target, required bool enabled}) {
    if (!canGrantJoyPlus(actor)) throw StateError('Owner permission required');
    return target.copyWith(joyPlus: enabled);
  }

  JoyUser changeRole({required JoyUser actor, required JoyUser target, required JoyRole role}) {
    if (!canManageRoles(actor)) throw StateError('Owner permission required');
    if (role == JoyRole.owner) throw StateError('Owner cannot be created by a client action');
    return target.copyWith(role: role);
  }
}

class JoyRepository {
  final JoyAuthService auth = JoyAuthService();

  final contactsInJoy = const <JoyUser>[
    JoyUser(id: 'mia', name: 'Mia', handle: 'mia', role: JoyRole.user, coins: 0, verified: true, joyPlus: false, unlimitedCoins: false, followers: 12800),
    JoyUser(id: 'artem', name: 'Artem', handle: 'artem', role: JoyRole.creator, coins: 120, verified: false, joyPlus: true, unlimitedCoins: false, followers: 8700),
    JoyUser(id: 'nika', name: 'Nika', handle: 'nika', role: JoyRole.user, coins: 40, verified: false, joyPlus: false, unlimitedCoins: false, followers: 3400),
  ];

  final statuses = <JoyStatus>[
    JoyStatus(authorId: 'mia', author: 'Mia', label: 'Late-night city ✨', video: true, viewed: false, viewers: 128, createdAt: DateTime(2026, 8, 13, 17)),
    JoyStatus(authorId: 'artem', author: 'Artem', label: 'New video is out', video: true, viewed: true, viewers: 84, createdAt: DateTime(2026, 8, 13, 14)),
    JoyStatus(authorId: 'nika', author: 'Nika', label: 'Mood today 💫', video: false, viewed: false, viewers: 42, createdAt: DateTime(2026, 8, 13, 12)),
  ];

  final posts = const <JoyPost>[
    JoyPost(author: 'Mia', caption: 'Late-night city lights ✨', mediaLabel: 'VIDEO 01', likes: 12400, comments: 382, shares: 94, mood: '✨'),
    JoyPost(author: 'Artem', caption: 'Today feels different.', mediaLabel: 'VIDEO 02', likes: 8700, comments: 211, shares: 61, mood: '🌙'),
    JoyPost(author: 'Nika', caption: 'Small moments, big joy.', mediaLabel: 'VIDEO 03', likes: 15600, comments: 492, shares: 133, mood: '💫'),
  ];
}
