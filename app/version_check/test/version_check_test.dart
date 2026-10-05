import 'package:test/test.dart';
import 'package:version_check/version_check.dart';

void main() {
  test('strips app and firmware tag prefixes', () {
    expect(parseVersion('v0.1.18').toString(), '0.1.18');
    expect(parseVersion('firmware-v0.1.0').toString(), '0.1.0');
    expect(parseVersion('0.1.18+42').toString(), '0.1.18');
  });

  test('accepts a greater major, minor, or patch', () {
    final previous = parseVersion('1.2.3')!;
    expect(parseVersion('2.0.0')!.isNewerThan(previous), isTrue);
    expect(parseVersion('1.3.0')!.isNewerThan(previous), isTrue);
    expect(parseVersion('1.2.4')!.isNewerThan(previous), isTrue);
  });

  test('rejects an equal or older version', () {
    final previous = parseVersion('1.3.0')!;
    expect(parseVersion('1.3.0')!.isNewerThan(previous), isFalse);
    expect(parseVersion('1.2.9')!.isNewerThan(previous), isFalse);
    expect(parseVersion('0.9.9')!.isNewerThan(parseVersion('1.0.0')!), isFalse);
  });
}
