// Copyright (c) 2017, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:jaguar_docstore/jaguar_docstore.dart';

class Player {
  String id;

  String name;

  String email;

  int hitpoints;

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'hitpoints': hitpoints,
      };
}

main() async {
  final Collection players = new CollectionInMem();
  players.ensureIndex([new IndexSetting('email')]);

  String plId1;
  String plId2;
  {
    Player pl1 = new Player()
      ..name = 'player1'
      ..email = 'player1@example.com'
      ..hitpoints = 99;
    plId1 = await players.insert(pl1.toMap());
    print(plId1);
  }

  {
    Player pl2 = new Player()
      ..name = 'player2'
      ..email = 'player2@example.com'
      ..hitpoints = 50;
    plId2 = await players.insert(pl2.toMap());
    print(plId2);
  }

  {
    final Map<String, dynamic> got = await players.findById(plId1);
    print(got);
  }

  {
    final Map<String, dynamic> got = await players
        .findOne(new RelationalCondition('email', 'player2@example.com'));
    print(got);
  }
}
