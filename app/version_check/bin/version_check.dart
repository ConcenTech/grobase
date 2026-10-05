import 'dart:io';

import 'package:args/args.dart';
import 'package:version_check/version_check.dart';

const kNext = 'next';
const kPrev = 'prev';

void main(List<String> arguments) {
  exitCode = 0;

  final parser = ArgParser()
    ..addOption(kPrev, abbr: 'p')
    ..addOption(kNext, abbr: 'n');

  final results = parser.parse(arguments);
  final prevRaw = results[kPrev];
  final nextRaw = results[kNext];

  if (prevRaw is! String || nextRaw is! String) {
    print('Expected string version numbers');
    exit(2);
  }

  final prev = parseVersion(prevRaw);
  final next = parseVersion(nextRaw);
  if (prev == null || next == null) {
    print('Unable to parse version numbers');
    print('prev: $prevRaw');
    print('next: $nextRaw');
    exit(2);
  }

  if (!next.isNewerThan(prev)) {
    print('Version older or unchanged ($next is not newer than $prev)');
    exitCode = 2;
  }
}
