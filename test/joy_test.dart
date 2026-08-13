import 'package:flutter_test/flutter_test.dart';
import 'package:joy/services.dart';
import 'package:joy/models.dart';

void main() {
  test('first registered user becomes Owner and later users are User', () {
    final auth = JoyAuthService();
    final first = auth.register('A', 'a');
    final second = auth.register('B', 'b');
    expect(first.role, JoyRole.owner);
    expect(first.unlimitedCoins, true);
    expect(second.role, JoyRole.user);
    expect(second.unlimitedCoins, false);
  });

  test('owner can grant JOY+ but user cannot', () {
    final auth = JoyAuthService();
    final owner = auth.register('A', 'a');
    final user = auth.register('B', 'b');
    expect(auth.grantJoyPlus(actor: owner, target: user, enabled: true).joyPlus, true);
    expect(() => auth.grantJoyPlus(actor: user, target: owner, enabled: false), throwsStateError);
  });
}
