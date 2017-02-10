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

  Player pl1 = new Player()
    ..name = 'player1'
    ..email = 'player1@example.com'
    ..hitpoints = 99;
  final String id = await players.insert(pl1.toMap());
  print(id);

  final Map<String, dynamic> got = await players.findById(id);
  print(got);
}
