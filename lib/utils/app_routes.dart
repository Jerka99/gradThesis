class AppRoutes {
  final bool isUnknown;
  final bool isHome;
  final bool isSecond;

  AppRoutes({
    this.isUnknown = false,
    this.isHome = false,
    this.isSecond = false,
});
  factory AppRoutes.home() => AppRoutes(isHome: true);
  factory AppRoutes.second() => AppRoutes(isSecond: true);
  factory AppRoutes.unknown() => AppRoutes(isUnknown: true);
}


