class NumberWithSymbol {
  final int number;
  final String symbol;
  NumberWithSymbol(this.number, this.symbol);

  static const Map<String, String> prettySymbols = {
    '+': '+',
    '-': '-',
    'x': '×',
    '/': '÷',
  };

  @override
  String toString() => '${prettySymbols[symbol]} $number';
}
