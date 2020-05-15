class NonFunctionalBounds {
  final double top;
  final double bottom;
  final double left;
  final double right;

  NonFunctionalBounds({
    this.bottom,
    this.left,
    this.right,
    this.top,
  });

  factory NonFunctionalBounds.fromJson(Map<String, dynamic> json) =>
      NonFunctionalBounds(
        bottom: json["bottom"],
        left: json["left"],
        right: json["right"],
        top: json["top"],
      );

  Map<String, dynamic> toJson() => {
        "bottom": bottom,
        "left": left,
        "right": right,
        "top": top,
      };
}
