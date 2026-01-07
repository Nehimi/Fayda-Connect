import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../providers/bank_provider.dart';
import '../providers/service_provider.dart';
import '../models/bank_model.dart';
import '../models/service_model.dart';
import 'bank_detail_screen.dart';
import 'service_detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Fetch all data
    final banks = ref.watch(bankListProvider);
    final passportServices = ref.watch(passportServiceProvider);
    final businessServices = ref.watch(businessServiceProvider);
    final educationServices = ref.watch(educationServiceProvider);
    final publicServices = ref.watch(publicServiceServiceProvider);
    final telecomServices = ref.watch(telecomServiceProvider);

    // 2. Aggregate
    final allServices = [
      ...passportServices,
      ...businessServices,
      ...educationServices,
      ...publicServices,
      ...telecomServices,
    ];

    // 3. Filter
    final List<dynamic> results = [];
    if (_query.isNotEmpty) {
      final lowerQuery = _query.toLowerCase();
      
      // Filter Banks
      for (var bank in banks) {
        if (bank.name.toLowerCase().contains(lowerQuery)) {
          results.add(bank);
        }
      }

      // Filter Services
      for (var service in allServices) {
        if (service.name.toLowerCase().contains(lowerQuery) || 
            service.description.toLowerCase().contains(lowerQuery) ||
            service.category.toLowerCase().contains(lowerQuery)) {
          results.add(service);
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: GlassCard(
          padding: EdgeInsets.zero,
          borderRadius: 20,
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: (val) => setState(() => _query = val),
            style: const TextStyle(color: AppColors.textMain),
            decoration: InputDecoration(
              hintText: 'Search services, banks...',
              hintStyle: const TextStyle(color: AppColors.textDim),
              prefixIcon: const Icon(LucideIcons.search, color: AppColors.textDim, size: 20),
              suffixIcon: _query.isNotEmpty 
                ? IconButton(
                    icon: const Icon(LucideIcons.x, color: AppColors.textDim, size: 16),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                  ) 
                : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('Cancel', style: TextStyle(color: AppColors.primary))
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _query.isEmpty
          ? _buildEmptyState()
          : results.isEmpty
              ? _buildNoResultsState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final item = results[index];
                    if (item is Bank) {
                      return _buildBankItem(context, item);
                    } else if (item is GeneralService) {
                      return _buildServiceItem(context, item);
                    }
                    return const SizedBox.shrink();
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.search, size: 64, color: AppColors.textDim.withOpacity(0.2)),
          const SizedBox(height: 16),
          const Text(
            'Type to search...',
            style: TextStyle(color: AppColors.textDim, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.searchX, size: 64, color: AppColors.textDim.withOpacity(0.2)),
          const SizedBox(height: 16),
          const Text(
            'No results found',
            style: TextStyle(color: AppColors.textDim, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildBankItem(BuildContext context, Bank bank) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => BankDetailScreen(bank: bank)));
          },
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Image.network(bank.logo, errorBuilder: (_,__,___) => const Icon(LucideIcons.landmark)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bank.name, style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 16)),
                    const Text('Bank', style: TextStyle(color: AppColors.textDim, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, color: AppColors.textDim, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceItem(BuildContext context, GeneralService service) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailScreen(service: service)));
          },
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Image.network(service.logo, errorBuilder: (_,__,___) => const Icon(LucideIcons.briefcase)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service.name, style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('${service.category} • Service', style: const TextStyle(color: AppColors.textDim, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, color: AppColors.textDim, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
