// Copyright (c) 2017, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library jaguar_docstore.base;

import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:more/char_matcher.dart';
import 'package:jaguar_docstore/src/expression.dart';

part 'id.dart';

abstract class Collection {
  Future<Null> ensureIndex(List<IndexSetting> indexes);

  Future<String> insert(Map<String, dynamic> object);

  Future<Map<String, dynamic>> findById(String id);

  Future<Map<String, dynamic>> findOne(Expression exp);

  Future<List<Map<String, dynamic>>> findAll(Expression exp, {int limit});

  Future<bool> updateById(String id);

  Future<bool> updateOne(Expression exp);

  Future<int> update(Expression exp);

  Future<bool> deleteById(String id);

  Future<bool> deleteOne(Expression exp);

  Future<int> delete(Expression exp);
}

class IndexSetting {
  final bool ascending;

  final String field;

  const IndexSetting(this.field, {this.ascending: false});
}
