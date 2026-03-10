enum TransactionTypeEnum {
  debit(1, 'سحب'),
  credit(2, 'إيداع');

  final int id;
  final String label;

  const TransactionTypeEnum(this.id, this.label);

  static TransactionTypeEnum? fromId(int? id) {
    for (var value in TransactionTypeEnum.values) {
      if (value.id == id) {
        return value;
      }
    }
    return null;
  }
}
