# JOY

JOY is a Flutter mobile prototype for a modern social network. It includes a dark premium UI, vertical feed, profiles, search, chat, notifications, creator analytics, JOY+, coins, gifts, achievements, mood/questions, live entry points, and a local role/privilege service.

## Security model

The client never receives authority to choose its own role or privileged balance. In this prototype, `JoyAuthService` owns the role assignment and privilege checks. The first registered account becomes Owner; every later account becomes User. In production, move these checks into a trusted backend/database transaction and issue only server-authoritative claims.

Owner-only operations include role changes, JOY+ grants, balance changes, moderation settings, and system settings. Unlimited Coins is represented as a server-side privilege (`unlimitedCoins`) rather than a mutable coin balance.

## Run

1. Install Flutter 3.22+.
2. Run `flutter pub get`.
3. Run `flutter run`.
4. Build Android with `flutter build apk --release`.

No paid AI API or external service is required for this prototype.


## JOY Status

Added a dedicated Status tab inspired by the status format users expect from messaging apps, with JOY's own UI. The prototype includes:
- 24-hour status model;
- photo/video/text status types;
- viewed/unviewed state;
- views and reactions-ready model;
- a "Contacts in JOY" surface;
- architecture point for permission-based device contact sync and server-side phone matching.

For production, device contacts must only be accessed after explicit permission, and matching must be handled by the backend without exposing phone numbers to other users.
