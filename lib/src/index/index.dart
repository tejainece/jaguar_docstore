library jaguar_docstore.index;

import 'package:multibtree/multibtree.dart';

class FlexComparable<T extends Comparable> implements Comparable<FlexComparable> {
  final bool ascending;

  T value;

  FlexComparable(this.value, {this.ascending: false});

  int compareTo(FlexComparable other) {
    if(ascending) return value.compareTo(other.value);
    return other.value.compareTo(value);
  }
}

class Indexed<KT extends Comparable> {
  final String field;

  final bool ascending;

  final _tree = new MultiBTree<FlexComparable<KT>, String>(2);

  Indexed(this.field, {this.ascending: false});

  FlexComparable<KT> _convert(KT key) => new FlexComparable<KT>(key);

  void add(KT key, String id) {
    _tree.insert(_convert(key), id);
  }

  bool remove(KT key, String id) => _tree.remove(_convert(key), id);

  Set<String> removeAll(KT key) => _tree.removeAll(_convert(key));

  Set<String> getIdsForKey(KT key) => _tree[_convert(key)];

  bool contains(KT key) => _tree.contains(_convert(key));

  bool containsId(KT key, String id) {
    Set<String> found = _tree[_convert(key)];
    if(found == null) return false;
    return found.contains(id);
  }

  void indexAll(Iterable<Map> docs) {
    //TODO _tree.clear();
    for(Map doc in docs) {
      //TODO parse field into sub-document and arrays
      _tree.insert(doc[field], doc['_id']);
    }
  }

  void insertRow(Map doc) {
    add(doc[field], doc['_id']);
  }
}