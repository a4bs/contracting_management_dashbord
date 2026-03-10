/// Screen size breakpoints for responsive design
/// Based on common device sizes and Material Design guidelines
enum ScreenSize {
  /// Mobile phones (portrait): 0 - 599px
  mobile(maxWidth: 599),

  /// Mobile phones (landscape) and small tablets: 600 - 839px
  mobileLarge(maxWidth: 839),

  /// Tablets (portrait): 840 - 1023px
  tablet(maxWidth: 1023),

  /// Tablets (landscape) and small desktops: 1024 - 1439px
  tabletLarge(maxWidth: 1439),

  /// Desktop and laptops: 1440 - 1919px
  desktop(maxWidth: 1919),

  /// Large desktops and monitors: 1920px+
  desktopLarge(maxWidth: double.infinity);

  const ScreenSize({required this.maxWidth});

  final double maxWidth;

  /// Get the minimum width for this screen size
  double get minWidth {
    switch (this) {
      case ScreenSize.mobile:
        return 0;
      case ScreenSize.mobileLarge:
        return 600;
      case ScreenSize.tablet:
        return 840;
      case ScreenSize.tabletLarge:
        return 1024;
      case ScreenSize.desktop:
        return 1440;
      case ScreenSize.desktopLarge:
        return 1920;
    }
  }

  /// Determine screen size from width
  static ScreenSize fromWidth(double width) {
    if (width < 600) return ScreenSize.mobile;
    if (width < 840) return ScreenSize.mobileLarge;
    if (width < 1024) return ScreenSize.tablet;
    if (width < 1440) return ScreenSize.tabletLarge;
    if (width < 1920) return ScreenSize.desktop;
    return ScreenSize.desktopLarge;
  }

  /// Check if current size is mobile (any mobile variant)
  bool get isMobile =>
      this == ScreenSize.mobile || this == ScreenSize.mobileLarge;

  /// Check if current size is tablet (any tablet variant)
  bool get isTablet =>
      this == ScreenSize.tablet || this == ScreenSize.tabletLarge;

  /// Check if current size is desktop (any desktop variant)
  bool get isDesktop =>
      this == ScreenSize.desktop || this == ScreenSize.desktopLarge;

  /// Check if screen is small (mobile only)
  bool get isSmall => this == ScreenSize.mobile;

  /// Check if screen is medium (mobile large, tablet, tablet large)
  bool get isMedium =>
      this == ScreenSize.mobileLarge ||
      this == ScreenSize.tablet ||
      this == ScreenSize.tabletLarge;

  /// Check if screen is large (desktop variants)
  bool get isLarge => isDesktop;
}
