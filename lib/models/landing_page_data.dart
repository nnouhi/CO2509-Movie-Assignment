class LandingPageData {
  final bool? isDarkTheme;
  final String? appLanguage;
  LandingPageData({
    required this.isDarkTheme,
    required this.appLanguage,
  });

  LandingPageData.initial()
      : isDarkTheme = false,
        appLanguage = 'English';

  LandingPageData copyWith({
    bool? isDarkTheme,
    String? appLanguage,
  }) {
    return LandingPageData(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      appLanguage: appLanguage ?? this.appLanguage,
    );
  }
}
