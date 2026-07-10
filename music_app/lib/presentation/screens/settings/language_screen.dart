import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../../../core/theme/app_theme.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLang = 'English (US)';
  final List<String> _languages = ['English (US)', 'English (UK)', 'Spanish', 'French', 'German', 'Japanese', 'Korean'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E1433), Color(0xFF0F0C29), Color(0xFF090909)],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: 110,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 72, bottom: 16),
                    title: const Text('Language', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26, letterSpacing: -0.5))
                        .animate().fadeIn(duration: 800.ms).slideX(begin: -0.2),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final lang = _languages[index];
                    final isSelected = lang == _selectedLang;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.02),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                        title: Text(lang, style: TextStyle(color: Colors.white, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, fontSize: 16)),
                        trailing: isSelected ? const Icon(Icons.check_rounded, color: AppTheme.primaryColor) : null,
                        onTap: () => setState(() => _selectedLang = lang),
                      ),
                    ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: -0.1);
                  },
                  childCount: _languages.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
