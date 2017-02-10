// Copyright (c) 2017, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

class UUID {
  static String newUUID() {
    return "000000000000000000000000"; //TODO make UUID
  }
}

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

class CollectionInMem implements Collection {
  final Map<String, Map<String, dynamic>> _documents = {};
  final Map<String, Map<dynamic, List<String>>> _indexes = {};

  Future<Null> _lock() async {
    //TODO lock
  }

  Future<Null> _unlock() async {
    //TODO
  }

  Future<RetVal> _context<RetVal>(Function func) async {
    await _lock();
    RetVal ret;
    try {
      ret = await func();
    } catch (_) {
      await _unlock();
      rethrow;
    }
    await _unlock();
    return ret;
  }

  Future<Null> ensureIndex(String key) async {
    //TODO
  }

  /// Inserts a document and returns the ID of the new document
  Future<String> insert(Map<String, dynamic> object) async {
    return await _context(() async {
      final String uuid = UUID.newUUID();
      object['_id'] = uuid;
      _documents[uuid] = object;
      for(final String key in _indexes.keys) {
        _indexes[key][object[key]].add(uuid);
      }
      return uuid;
    });
  }

  Future<Map<String, dynamic>> findById(String id) async {
    return _documents[id];
  }

  Future<Map<String, dynamic>> findOne(/* TODO */) async {
    //TODO
  }

  Future<List<Map<String, dynamic>>> findAll(/* TODO */) async {
    //TODO
  }

  Future<bool> updateById(/* TODO */) async {
    //TODO
  }

  Future<bool> updateOne(/* TODO */) async {
    //TODO
  }

  Future<int> update(/* TODO */) async {
    //TODO
  }

  Future<bool> deleteById(/* TODO */) async {
    //TODO
  }

  Future<bool> deleteOne(/* TODO */) async {
    //TODO
  }

  Future<int> delete(/* TODO */) async {
    //TODO
  }

  static const String idField = '_id';
}
