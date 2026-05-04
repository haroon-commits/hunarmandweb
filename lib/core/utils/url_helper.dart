// Single file — no conditional imports needed.
// dart:js_interop compiles on all platforms (Dart 3.3+),
// but JS execution is guarded by kIsWeb at runtime.

import 'package:flutter/foundation.dart';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// Writes the page index to the URL hash so the browser preserves it on reload.
void setUrlPage(int index) {
  if (!kIsWeb) return;
  try {
    // Sets window.location.hash = 'page=3'
    // The browser keeps this in the URL across F5 reloads.
    final location = globalContext['location'] as JSObject;
    location['hash'] = 'page=$index'.toJS;
  } catch (_) {}
}

/// Reads the page index from the URL hash on startup.
int getUrlPage() {
  if (!kIsWeb) return 0;
  try {
    // Try js_interop first
    final location = globalContext['location'] as JSObject;
    final hash = (location['hash'] as JSString?)?.toDart ?? '';
    final match = RegExp(r'page=(\d+)').firstMatch(hash);
    if (match != null) {
      return int.tryParse(match.group(1) ?? '0') ?? 0;
    }
  } catch (_) {
    // Fallback: Uri.base works on Flutter web without any imports
    try {
      final fragment = Uri.base.fragment;
      final match = RegExp(r'page=(\d+)').firstMatch(fragment);
      if (match != null) {
        return int.tryParse(match.group(1) ?? '0') ?? 0;
      }
    } catch (_) {}
  }
  return 0;
}
