// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

List<String> soundTypeToFilename(SfxType type) {
  switch (type) {
    case SfxType.asteroidExplosion:
      return const [
        'asteroid_explosion.ogg',
        'asteroid_explosion1.ogg',
        'asteroid_explosion2.ogg',
        'asteroid_explosion3.ogg',
      ];
    case SfxType.shipExplosion:
      return const ['ship_explosion.ogg'];
    case SfxType.laser:
      return const [
        'space_sfx1/laser1.ogg',
        'space_sfx1/laser2.ogg',
        'space_sfx1/laser3.ogg',
      ];

    case SfxType.gameOver:
      return const [
        'space_sfx1/game-over.ogg',
      ];
    case SfxType.warp:
      return const [
        'space_sfx1/warpin.ogg',
      ];
    case SfxType.huhsh:
      return const [
        'hash1.mp3',
        'hash2.mp3',
        'hash3.mp3',
      ];
    case SfxType.wssh:
      return const [
        'wssh1.mp3',
        'wssh2.mp3',
        'dsht1.mp3',
        'ws1.mp3',
        'spsh1.mp3',
        'hh1.mp3',
        'hh2.mp3',
        'kss1.mp3',
      ];
    case SfxType.buttonTap:
      return const [
        'k1.mp3',
        'k2.mp3',
        'p1.mp3',
        'p2.mp3',
      ];
    case SfxType.congrats:
      return const [
        'yay1.mp3',
        'wehee1.mp3',
        'oo1.mp3',
      ];
    case SfxType.erase:
      return const [
        'fwfwfwfwfw1.mp3',
        'fwfwfwfw1.mp3',
      ];
    case SfxType.swishSwish:
      return const [
        'swishswish1.mp3',
      ];
  }
}

/// Allows control over loudness of different SFX types.
double soundTypeToVolume(SfxType type) {
  switch (type) {
    case SfxType.huhsh:
      return 0.4;
    case SfxType.wssh:
      return 0.2;
    case SfxType.gameOver:
      return 0.5;
    case SfxType.warp:
    case SfxType.laser:
    case SfxType.buttonTap:
    case SfxType.congrats:
    case SfxType.erase:
    case SfxType.swishSwish:
    case SfxType.shipExplosion:
    case SfxType.asteroidExplosion:
      return 1.0;
  }
}

enum SfxType {
  shipExplosion,
  asteroidExplosion,
  warp,
  gameOver,
  laser,
  huhsh,
  wssh,
  buttonTap,
  congrats,
  erase,
  swishSwish,
}
