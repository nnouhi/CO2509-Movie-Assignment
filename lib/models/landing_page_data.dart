class LandingPageData {
  final bool? isDarkTheme;

  LandingPageData({
    required this.isDarkTheme,
  });

  LandingPageData.initial() : isDarkTheme = false;

  LandingPageData copyWith({
    bool? isDarkTheme,
  }) {
    return LandingPageData(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
    );
  }
}
