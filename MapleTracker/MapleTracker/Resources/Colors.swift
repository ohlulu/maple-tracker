import SwiftUI

enum AppColors {
    // Background colors - 使用較暖的深灰色系 (Material Design Dark #121212 為基礎)
    static let background = Color(red: 0.071, green: 0.071, blue: 0.071) // #121212
    static let surface = Color(red: 0.118, green: 0.118, blue: 0.118) // #1e1e1e  
    static let surfaceVariant = Color(red: 0.149, green: 0.149, blue: 0.149) // #262626
    
    // Text colors - 更柔和的對比度
    static let onBackground = Color(red: 0.87, green: 0.87, blue: 0.87) // #dedede
    static let onSurface = Color(red: 0.87, green: 0.87, blue: 0.87) // #dedede
    static let onSurfaceVariant = Color(red: 0.67, green: 0.67, blue: 0.67) // #ababab
    static let secondary = Color(red: 0.55, green: 0.55, blue: 0.55) // #8c8c8c
    
    // Interactive colors
    static let primary = Color(red: 0.56, green: 0.56, blue: 0.56) // #8f8f8f
    static let primaryVariant = Color(red: 0.45, green: 0.45, blue: 0.45) // #737373
    
    // Accent colors
    static let accent = Color(red: 0.40, green: 0.73, blue: 0.42) // #67bb6a (柔和綠色)
    static let accentRed = Color(red: 0.80, green: 0.42, blue: 0.40) // #cc6b66 (稍深的柔和紅色)
}