// Conditional Export: Auf iOS/Android wird SQLite verwendet,
// auf Web ein In-Memory-Speicher mit Demo-Daten.
export 'database_service_io.dart'
    if (dart.library.html) 'database_service_web.dart';
