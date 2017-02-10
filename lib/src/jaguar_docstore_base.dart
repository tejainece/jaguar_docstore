// Copyright (c) 2017, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library jaguar_docstore.base;

import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:more/char_matcher.dart';

part 'id.dart';

abstract class Collection {
  Future<Null> ensureIndex(String key);

  Future<String> insert(Map<String, dynamic> object);

  Future<Map<String, dynamic>> findById(String id);

  Future<Map<String, dynamic>> findOne(/* TODO */);

  Future<List<Map<String, dynamic>>> findAll(/* TODO */);

  Future<bool> updateById(/* TODO */);

  Future<bool> updateOne(/* TODO */);

  Future<int> update(/* TODO */);

  Future<bool> deleteById(/* TODO */);

  Future<bool> deleteOne(/* TODO */);

  Future<int> delete(/* TODO */);
}
