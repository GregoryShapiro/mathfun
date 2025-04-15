class GameBlock {
  final int value;
  final int x;
  final int y;

  GameBlock({required this.value, required this.x, required this.y});

  GameBlock copyWith({int? value, int? x, int? y}) {
    return GameBlock(
      value: value ?? this.value,
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
}
