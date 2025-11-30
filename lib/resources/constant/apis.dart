import 'package:v_al_sam_v02/config.dart';

/// Clase centralizada para todas las APIs externas.
/// 
/// Las URLs se cargan desde las variables de entorno definidas en .env
/// Ver .env.example para la configuración requerida.
class Api {
  // ============================================
  // GOOGLE APPS SCRIPT APIs
  // ============================================
  
  /// API endpoint para enviar SOLPE
  static String get enviarSolpe => AppConfig.apiSolpe;

  /// API endpoint para FEM
  static String get femString => AppConfig.apiFem;

  /// API endpoint para SAM
  static String get samString => AppConfig.apiSam;
  
  /// API endpoint para CHATARRA
  static String get chatarraString => AppConfig.apiChatarra;

  /// URI parseada para SAM
  static Uri get sam => Uri.parse(samString);

  /// URI parseada para FEM
  static Uri get fem => Uri.parse(femString);
  
  /// URI parseada para CHATARRA
  static Uri get chatarraUrl => Uri.parse(chatarraString);

  // ============================================
  // SUPABASE APIs
  // ============================================
  
  /// URL de Supabase FEM/SAM (principal)
  static String get femSamSupUrl => AppConfig.supabaseUrl;
  
  /// Clave de Supabase FEM/SAM (principal)
  static String get femSamSupKey => AppConfig.supabaseAnonKey;

  /// URL de Supabase FEM/SAM (nueva instancia)
  static String get femSamSupUrlNew => AppConfig.supabaseUrlNew;
  
  /// Clave de Supabase FEM/SAM (nueva instancia)
  static String get femSamSupKeyNew => AppConfig.supabaseAnonKeyNew;

  /// URL de Supabase para datos SAP
  static String get sapSupUrl => AppConfig.supabaseUrlSap;
  
  /// Clave de Supabase para datos SAP
  static String get sapSupKey => AppConfig.supabaseAnonKeySap;

  /// URL de Supabase para LCL
  static String get lclSupUrl => AppConfig.supabaseUrlLcl;
  
  /// Clave de Supabase para LCL
  static String get lclSupKey => AppConfig.supabaseAnonKeyLcl;
}
