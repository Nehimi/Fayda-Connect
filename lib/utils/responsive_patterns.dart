// Responsive Design Quick Reference Guide
// Copy-paste these patterns when creating new screens

// ============================================
// 1. IMPORT THE RESPONSIVE UTILITY
// ============================================
import '../utils/responsive.dart';

// ============================================
// 2. PADDING & MARGINS
// ============================================

// Horizontal padding (adapts: 16px → 24px → 32px → 40px)
padding: EdgeInsets.symmetric(horizontal: context.responsive.horizontalPadding)

// All-around padding
padding: EdgeInsets.all(context.responsive.horizontalPadding)

// Custom padding with responsive spacing
padding: EdgeInsets.fromLTRB(
  context.responsive.horizontalPadding,
  context.responsive.getSpacing(20),
  context.responsive.horizontalPadding,
  context.responsive.getSpacing(16),
)

// ============================================
// 3. SPACING (SizedBox)
// ============================================

SizedBox(height: context.responsive.getSpacing(16))
SizedBox(width: context.responsive.getSpacing(20))

// ============================================
// 4. TEXT & FONTS
// ============================================

Text(
  'Your Text',
  style: TextStyle(
    fontSize: context.responsive.getFontSize(16),
    fontWeight: FontWeight.bold,
  ),
)

// ============================================
// 5. ICONS
// ============================================

Icon(
  Icons.home,
  size: context.responsive.getIconSize(24),
)

// ============================================
// 6. BUTTONS
// ============================================

ElevatedButton(
  style: ElevatedButton.styleFrom(
    minimumSize: Size(double.infinity, context.responsive.buttonHeight),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        context.responsive.getBorderRadius(16)
      ),
    ),
  ),
  child: Text(
    'Button',
    style: TextStyle(fontSize: context.responsive.getFontSize(16)),
  ),
)

// ============================================
// 7. BORDER RADIUS
// ============================================

BorderRadius.circular(context.responsive.getBorderRadius(20))

// ============================================
// 8. GRIDS
// ============================================

GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: context.responsive.gridCrossAxisCount,
    crossAxisSpacing: context.responsive.getSpacing(16),
    mainAxisSpacing: context.responsive.getSpacing(16),
    childAspectRatio: context.responsive.isTablet ? 1.0 : 0.85,
  ),
)

// ============================================
// 9. CARDS & CONTAINERS
// ============================================

Container(
  width: context.responsive.cardWidth,
  padding: EdgeInsets.all(context.responsive.getSpacing(20)),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(
      context.responsive.getBorderRadius(16)
    ),
  ),
)

// ============================================
// 10. CONDITIONAL LAYOUTS
// ============================================

// Show different layouts based on screen size
if (context.responsive.isSmallPhone) {
  // Layout for small phones
} else if (context.responsive.isTablet) {
  // Layout for tablets
} else {
  // Default layout for normal phones
}

// ============================================
// 11. QR CODES
// ============================================

QrImageView(
  data: qrData,
  size: context.responsive.qrCodeSize,
)

// ============================================
// 12. BOTTOM SHEETS
// ============================================

showModalBottomSheet(
  context: context,
  constraints: BoxConstraints(
    maxHeight: context.responsive.bottomSheetMaxHeight,
  ),
  builder: (context) => Container(
    padding: EdgeInsets.all(context.responsive.horizontalPadding),
    // ... content
  ),
)

// ============================================
// 13. DIALOGS
// ============================================

Dialog(
  child: Container(
    width: context.responsive.dialogWidth,
    padding: EdgeInsets.all(context.responsive.horizontalPadding),
    // ... content
  ),
)

// ============================================
// 14. SCREEN SIZE CHECKS
// ============================================

// Check screen type
context.responsive.isSmallPhone  // < 360dp
context.responsive.isPhone       // 360-600dp
context.responsive.isLargePhone  // 600-720dp
context.responsive.isTablet      // >= 720dp

// Get screen dimensions
context.responsive.width
context.responsive.height

// ============================================
// 15. COMPLETE SCREEN TEMPLATE
// ============================================

/*
import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class MyResponsiveScreen extends StatelessWidget {
  const MyResponsiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Screen',
          style: TextStyle(
            fontSize: context.responsive.getFontSize(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.responsive.horizontalPadding),
        child: Column(
          children: [
            SizedBox(height: context.responsive.getSpacing(20)),
            
            // Your content here with responsive sizing
            Text(
              'Hello World',
              style: TextStyle(
                fontSize: context.responsive.getFontSize(24),
              ),
            ),
            
            SizedBox(height: context.responsive.getSpacing(16)),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(
                  double.infinity, 
                  context.responsive.buttonHeight
                ),
              ),
              onPressed: () {},
              child: Text(
                'Click Me',
                style: TextStyle(
                  fontSize: context.responsive.getFontSize(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
