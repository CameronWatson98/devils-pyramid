class NumberWithSymbol {
  final int number;
  final String symbol;
  NumberWithSymbol(this.number, this.symbol);

  @override
  String toString() => '$symbol$number';
}
