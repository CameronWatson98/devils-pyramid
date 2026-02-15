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

  /// Converts this NumberWithSymbol to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'symbol': symbol,
    };
  }

  /// Creates a NumberWithSymbol from a JSON map
  factory NumberWithSymbol.fromJson(Map<String, dynamic> json) {
    return NumberWithSymbol(
      json['number'] as int,
      json['symbol'] as String,
    );
  }
}
