import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/service_model.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/app_drawer.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import 'service_detail_screen.dart';

class ServiceListScreen extends ConsumerWidget {
  final String title;
  final ProviderListenable<List<GeneralService>> serviceProvider;

  const ServiceListScreen({
    super.key,
    required this.title,
    required this.serviceProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(serviceProvider);
    final currentLang = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(_getLocalizedTitle(ref.watch(languageProvider), title)),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: GlassCard(
              padding: EdgeInsets.zero,
              borderRadius: 20,
              child: TextField(
                decoration: InputDecoration(
                  hintText: currentLang == AppLanguage.english ? 'Search for a service...' : 'አገልግሎት ፈልግ...',
                  hintStyle: const TextStyle(color: AppColors.textDim),
                  prefixIcon: const Icon(LucideIcons.search, color: AppColors.textDim, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics: const BouncingScrollPhysics(),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GlassCard(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Hero(
                        tag: service.id,
                        child: Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Image.network(
                            service.logo,
                            errorBuilder: (context, error, stackTrace) => 
                              const Icon(LucideIcons.component, color: AppColors.primary),
                          ),
                        ),
                      ),
                      title: Text(
                        service.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: AppColors.textMain,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          service.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.textDim, fontSize: 13),
                        ),
                      ),
                      trailing: const Icon(LucideIcons.chevronRight, color: AppColors.textDim, size: 20),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceDetailScreen(service: service),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  String _getLocalizedTitle(AppLanguage lang, String currentTitle) {
    if (currentTitle.toLowerCase().contains('passport')) return L10n.get(lang, 'passport');
    if (currentTitle.toLowerCase().contains('business')) return L10n.get(lang, 'business');
    if (currentTitle.toLowerCase().contains('education')) return L10n.get(lang, 'education');
    if (currentTitle.toLowerCase().contains('public')) return L10n.get(lang, 'public');
    if (currentTitle.toLowerCase().contains('telecom')) return L10n.get(lang, 'telecom');
    return currentTitle;
  }
}
