import 'package:flutter/material.dart';

/// Responsive utility class for adaptive layouts across all mobile devices
class Responsive {
  final BuildContext context;
  
  Responsive(this.context);
  
  /// Get screen width
  double get width => MediaQuery.of(context).size.width;
  
  /// Get screen height
  double get height => MediaQuery.of(context).size.height;
  
  /// Check if device is a small phone (width < 360dp)
  bool get isSmallPhone => width < 360;
  
  /// Check if device is a normal phone (360dp <= width < 600dp)
  bool get isPhone => width >= 360 && width < 600;
  
  /// Check if device is a large phone/phablet (600dp <= width < 720dp)
  bool get isLargePhone => width >= 600 && width < 720;
  
  /// Check if device is a tablet (width >= 720dp)
  bool get isTablet => width >= 720;
  
  /// Get responsive horizontal padding
  double get horizontalPadding {
    if (isSmallPhone) return 16;
    if (isPhone) return 24;
    if (isLargePhone) return 32;
    return 40; // tablet
  }
  
  /// Get responsive vertical padding
  double get verticalPadding {
    if (isSmallPhone) return 12;
    if (isPhone) return 16;
    return 20;
  }
  
  /// Get responsive font size multiplier
  double get fontScale {
    if (isSmallPhone) return 0.9;
    if (isTablet) return 1.1;
    return 1.0;
  }
  
  /// Get grid cross axis count based on screen size
  int get gridCrossAxisCount {
    if (isSmallPhone) return 2;
    if (isPhone) return 2;
    if (isLargePhone) return 3;
    return 4; // tablet
  }
  
  /// Get responsive card width for horizontal scrolling
  double get cardWidth {
    if (isSmallPhone) return width * 0.75;
    if (isPhone) return 260;
    if (isLargePhone) return 300;
    return 350; // tablet
  }
  
  /// Get responsive icon size
  double getIconSize(double baseSize) {
    return baseSize * fontScale;
  }
  
  /// Get responsive font size
  double getFontSize(double baseSize) {
    return baseSize * fontScale;
  }
  
  /// Get responsive spacing
  double getSpacing(double baseSpacing) {
    if (isSmallPhone) return baseSpacing * 0.8;
    if (isTablet) return baseSpacing * 1.2;
    return baseSpacing;
  }
  
  /// Get responsive border radius
  double getBorderRadius(double baseRadius) {
    if (isSmallPhone) return baseRadius * 0.9;
    return baseRadius;
  }
  
  /// Get QR code size
  double get qrCodeSize {
    if (isSmallPhone) return 200;
    if (isPhone) return 260;
    if (isLargePhone) return 300;
    return 350; // tablet
  }
  
  /// Get responsive button height
  double get buttonHeight {
    if (isSmallPhone) return 48;
    if (isPhone) return 56;
    return 60;
  }
  
  /// Get responsive app bar height
  double get appBarHeight {
    if (isSmallPhone) return 56;
    return 60;
  }
  
  /// Get responsive bottom sheet max height
  double get bottomSheetMaxHeight => height * 0.85;
  
  /// Get responsive dialog width
  double get dialogWidth {
    if (isSmallPhone) return width * 0.9;
    if (isPhone) return width * 0.85;
    return 500; // max width for tablets
  }
}

/// Extension to easily access Responsive from BuildContext
extension ResponsiveExtension on BuildContext {
  Responsive get responsive => Responsive(this);
}
