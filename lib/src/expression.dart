library jaguar_docstore.expression;

class Equality {
  static bool isEqual(dynamic comparee, dynamic compared) {
    if(comparee is Map) {
      if(compared is! Map) return null;
      if(comparee.keys.length != compared.keys.length) return false;
      for(String key in comparee.keys) {
        if(!isEqual(comparee[key], compared[key])) return false;
      }
      return true;
    } else if(comparee is List) {
      if(compared is! List) return null;
      if(comparee.length != compared.length) return false;
      for(int idx = 0; idx < comparee.length; idx++) {
        if(!isEqual(comparee[idx], compared[idx])) return false;
      }
      return true;
    }
    return comparee == compared;
  }
}

class RelationalOperator {
  final int id;

  final String code;

  const RelationalOperator(this.id, this.code);

  static const int eqId = 0;

  static const RelationalOperator eq = const RelationalOperator(0, '=');

  static const RelationalOperator lt = const RelationalOperator(1, '<');

  static const RelationalOperator lte = const RelationalOperator(2, '<=');

  static const RelationalOperator gte = const RelationalOperator(3, '>=');

  static const RelationalOperator gt = const RelationalOperator(4, '>');

  static const RelationalOperator ne = const RelationalOperator(5, '!=');
}

class RelationalCondition implements Expression {
  RelationalCondition(this.name, this.value, {this.op: RelationalOperator.eq});

  RelationalCondition.eq(this.name, this.value): op = RelationalOperator.eq;

  String name;

  RelationalOperator op;

  dynamic value;

  int get length => 1;
}

class AndExpression implements Expression {
  final List<Expression> expressions = [];

  int get length => expressions.length;
}

class OrExpression implements Expression {
  List<Expression> expressions;

  int get length => 1;
}

class NotExpression implements Expression {
  Expression expression;

  int get length => 1;
}

abstract class Expression {
  int get length;
}