import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Archivo de configuración centralizado para credenciales y variables de entorno.
/// 
/// Las credenciales se cargan desde el archivo .env en la raíz del proyecto.
/// Ver .env.example para la lista de variables requeridas.
class AppConfig {
  // ============================================
  // SUPABASE CONFIGURATION
  // ============================================
  
  /// URL principal de Supabase
  static String get supabaseUrl => 
      dotenv.env['SUPABASE_URL'] ?? 'https://your-project.supabase.co';
  
  /// Clave anónima principal de Supabase
  static String get supabaseAnonKey => 
      dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  /// URL secundaria de Supabase (nuevo proyecto)
  static String get supabaseUrlNew => 
      dotenv.env['SUPABASE_URL_NEW'] ?? 'https://your-new-project.supabase.co';
  
  /// Clave anónima secundaria de Supabase
  static String get supabaseAnonKeyNew => 
      dotenv.env['SUPABASE_ANON_KEY_NEW'] ?? '';

  /// URL de Supabase para datos SAP (tercer proyecto)
  static String get supabaseUrlSap => 
      dotenv.env['SUPABASE_URL_SAP'] ?? 'https://your-sap-project.supabase.co';
  
  /// Clave anónima de Supabase SAP
  static String get supabaseAnonKeySap => 
      dotenv.env['SUPABASE_ANON_KEY_SAP'] ?? '';

  /// URL de Supabase para LCL (cuarto proyecto)
  static String get supabaseUrlLcl => 
      dotenv.env['SUPABASE_URL_LCL'] ?? 'https://your-lcl-project.supabase.co';
  
  /// Clave anónima de Supabase LCL
  static String get supabaseAnonKeyLcl => 
      dotenv.env['SUPABASE_ANON_KEY_LCL'] ?? '';

  // ============================================
  // GOOGLE APPS SCRIPT APIs
  // ============================================
  
  /// API endpoint para SAM
  static String get apiSam => 
      dotenv.env['API_SAM'] ?? '';

  /// API endpoint para FEM
  static String get apiFem => 
      dotenv.env['API_FEM'] ?? '';

  /// API endpoint para SOLPE
  static String get apiSolpe => 
      dotenv.env['API_SOLPE'] ?? '';

  /// API endpoint para CHATARRA
  static String get apiChatarra => 
      dotenv.env['API_CHATARRA'] ?? '';

  // ============================================
  // UTILITY METHODS
  // ============================================
  
  /// Determina si la aplicación está en modo depuración
  static bool get isDebug {
    bool isDebugMode = false;
    assert(isDebugMode = true); // En modo depuración, esta instrucción establece isDebugMode a true
    return isDebugMode;
  }

  /// Verifica si todas las credenciales requeridas están configuradas
  static bool get isConfigured {
    return supabaseUrl.isNotEmpty && 
           supabaseAnonKey.isNotEmpty && 
           apiSam.isNotEmpty;
  }

  /// Carga las variables de entorno. Debe llamarse antes de usar cualquier configuración.
  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
  }
}
