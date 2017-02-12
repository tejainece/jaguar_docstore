import 'dart:async';
import 'package:jaguar_docstore/src/jaguar_docstore_base.dart';
import 'package:jaguar_docstore/src/expression.dart';
import 'package:jaguar_docstore/src/index/index.dart';

class CollectionInMem implements Collection {
  final _indexes = <String, Indexed>{};
  final Map<String, Map<String, dynamic>> _documents = {};

  CollectionInMem() {
    _indexes['_id'] = new Indexed<String>('_id');
  }

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

  Future<Null> ensureIndex(List<IndexSetting> indexes) async {
    if (indexes.length == 0) return;
    if (indexes.length == 1) {
      final IndexSetting index = indexes.first;
      if (_indexes.containsKey(index.field)) {
        throw new Exception('Such indexes already exists!');
      }
      _indexes[index.field] =
          new Indexed(index.field, ascending: index.ascending);
      _indexes[index.field].indexAll(_documents.values);
      return;
    }

    throw new Exception('Composite indexes not supported yet!');
    //TODO
  }

  /// Inserts a document and returns the ID of the new document
  Future<String> insert(Map<String, dynamic> object) async {
    return await _context(() async {
      final String id = Id.create.id;
      object['_id'] = id;
      _documents[id] = object;
      _updateIndexForInsert(object);
      return id;
    });
  }

  Future<Map<String, dynamic>> findById(String id) async {
    return _documents[id];
  }

  Future<Map<String, dynamic>> findOne(Expression exp) async {
    if (exp.length == 0)
      return _documents.values.isNotEmpty ? _documents.values.first : null;
    List<Map> filtered = _documents.values.toList();

    if (exp is RelationalCondition) {
      List<Map> res = _filterByRelationalCondition(exp);
      if (res != null) {
        filtered = res;
        exp = null;
      }
    } else if (exp is AndExpression) {
      for (Expression e in exp.expressions) {
        if (e is RelationalCondition) {
          List<Map> res = _filterByRelationalCondition(e);
          if (res != null) {
            filtered = res;
            exp.expressions.remove(e);
            break;
          }
        }
      }
    }

    if (exp != null && exp.length != 0) {
      //TODO filter further
    }

    return filtered.isNotEmpty ? filtered.first : null;
  }

  Future<List<Map<String, dynamic>>> findAll(Expression exp,
      {int limit}) async {
    List<Map> filtered = _documents.values.toList();
    if (exp.length == 0) return filtered;

    if (exp is RelationalCondition) {
      List<Map> res = _filterByRelationalCondition(exp);
      if (res != null) {
        filtered = res;
        exp = null;
      }
    } else if (exp is AndExpression) {
      for (Expression e in exp.expressions) {
        if (e is RelationalCondition) {
          List<Map> res = _filterByRelationalCondition(e);
          if (res != null) {
            filtered = res;
            exp.expressions.remove(e);
            break;
          }
        }
      }
    }

    if (exp != null && exp.length != 0) {
      //TODO filter further
    }

    return filtered;
  }

  Future<bool> updateById(String id) async {
    throw new Exception('Not implemented yet!');
  }

  Future<bool> updateOne(Expression exp) async {
    throw new Exception('Not implemented yet!');
  }

  Future<int> update(Expression exp) async {
    throw new Exception('Not implemented yet!');
  }

  Future<bool> deleteById(String id) async {
    throw new Exception('Not implemented yet!');
  }

  Future<bool> deleteOne(Expression exp) async {
    throw new Exception('Not implemented yet!');
  }

  Future<int> delete(Expression exp) async {
    throw new Exception('Not implemented yet!');
  }

  List<Map<String, dynamic>> _filterByRelationalCondition(
      RelationalCondition cond) {
    final Indexed indexed = _indexes[cond.name];
    if (indexed != null) {
      switch (cond.op) {
        case RelationalOperator.eq:
          Set<String> filteredIds = indexed.getIdsForKey(cond.value);
          return _idsToDocs(filteredIds);
          break;
        //TODO implement other conditions
      }
    }

    return null;
  }

  List<Map<String, dynamic>> _idsToDocs(Set<String> ids) {
    List<Map<String, dynamic>> ret = [];

    for (String id in ids) {
      final Map<String, dynamic> doc = _documents[id];
      if (doc is Map) ret.add(doc);
    }

    return ret;
  }

  void _updateIndexForInsert(Map doc) {
    for (final String key in _indexes.keys) {
      _indexes[key].insertRow(doc);
    }
  }

  static const String idField = '_id';
}
