enum FlavorType { free, paid }

class FlavorConfig {
  final FlavorType flavor;
  final String appTitle;

  FlavorConfig._({
    required this.flavor,
    required this.appTitle,
  });

  static FlavorConfig? _instance;

  static FlavorConfig get instance {
    assert(
      _instance != null,
      'FlavorConfig has not been initialized. '
      'Call FlavorConfig.initialize() before using it.',
    );
    return _instance!;
  }

  static void initialize({
    required FlavorType flavor,
    required String appTitle,
  }) {
    _instance = FlavorConfig._(
      flavor: flavor,
      appTitle: appTitle,
    );
  }

  bool get isPaid => flavor == FlavorType.paid;
  bool get isFree => flavor == FlavorType.free;

  String get flavorName => flavor == FlavorType.paid ? 'paid' : 'free';
}

