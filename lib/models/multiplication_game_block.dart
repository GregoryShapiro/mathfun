class MultiplicationGameBlock {
  final String value;
  final String equation;
  final int x;
  final int y;
  final bool isPipe;

  MultiplicationGameBlock({
    required this.value,
    required this.equation,
    required this.x,
    required this.y,
    this.isPipe = false,
  });

  MultiplicationGameBlock copyWith({
    String? value,
    String? equation,
    int? x,
    int? y,
    bool? isPipe,
  }) {
    return MultiplicationGameBlock(
      value: value ?? this.value,
      equation: equation ?? this.equation,
      x: x ?? this.x,
      y: y ?? this.y,
      isPipe: isPipe ?? this.isPipe,
    );
  }
}