class LandingPageData {
  final bool? isDarkTheme;
  final String? appLanguage;
  final bool? hasNetworkConnection;

  LandingPageData({
    required this.isDarkTheme,
    required this.appLanguage,
    this.hasNetworkConnection,
  });

  LandingPageData.initial()
      : isDarkTheme = false,
        appLanguage = 'English',
        hasNetworkConnection = true;

  LandingPageData copyWith({
    bool? isDarkTheme,
    String? appLanguage,
    bool? hasNetworkConnection,
  }) {
    return LandingPageData(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      appLanguage: appLanguage ?? this.appLanguage,
      hasNetworkConnection: hasNetworkConnection ?? this.hasNetworkConnection,
    );
  }
}
