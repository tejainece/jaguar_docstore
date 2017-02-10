import 'dart:async';
import 'package:jaguar_docstore/src/jaguar_docstore_base.dart';
import 'package:jaguar_docstore/src/inmem/expression.dart';

class Indexed {
  final String field;

  Indexed(this.field);
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
      final String id = Id.create.id;
      object['_id'] = id;
      _documents[id] = object;
      for(final String key in _indexes.keys) {
        _indexes[key][object[key]].add(id);
      }
      return id;
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

  List<Map<String, dynamic>> _filter(Expression exp) {
    //TODO
  }

  static const String idField = '_id';
}