import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final t = AppLocalizations.of(context)!;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: PopupMenuButton<Locale>(
        tooltip: t.language,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language, color: Colors.indigo),
              const SizedBox(width: 8),
              Text(
                t.language,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                localeProvider.locale.languageCode.toUpperCase(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
        ),
        onSelected: (Locale locale) {
          localeProvider.setLocale(locale);
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
          PopupMenuItem<Locale>(
            value: const Locale('en'),
            child: _buildLanguageItem('English', 'EN', 'en'),
          ),
          PopupMenuItem<Locale>(
            value: const Locale('ru'),
            child: _buildLanguageItem('Русский', 'RU', 'ru'),
          ),
          PopupMenuItem<Locale>(
            value: const Locale('es'),
            child: _buildLanguageItem('Español', 'ES', 'es'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(String name, String code, String languageCode) {
    return Row(
      children: [
        Text(
          code,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.indigo.shade700,
          ),
        ),
        const SizedBox(width: 12),
        Text(name),
      ],
    );
  }
}