import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/order_provider.dart';
import '../models/order_model.dart';
import 'success_screen.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final String bankName;
  const PaymentScreen({super.key, required this.bankName});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  String? selectedMethod;
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(L10n.get(ref.watch(languageProvider), 'checkout')),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              L10n.get(lang, 'select_method'),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textMain, letterSpacing: -0.5),
            ),
            const SizedBox(height: 8),
            Text(
              '${L10n.get(lang, 'total_amount')}: 50.00 ETB',
              style: const TextStyle(color: AppColors.textDim, fontSize: 16),
            ),
            const SizedBox(height: 32),
            _buildPaymentMethod(
              id: 'telebirr',
              name: 'Telebirr',
              image: 'https://upload.wikimedia.org/wikipedia/en/3/3f/Telebirr_logo.png',
            ),
            const SizedBox(height: 16),
            _buildPaymentMethod(
              id: 'mpesa',
              name: 'M-Pesa',
              image: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/M-Pesa_Logo_-_PNG.png/1200px-M-Pesa_Logo_-_PNG.png',
            ),
            const SizedBox(height: 16),
            _buildPaymentMethod(
              id: 'chapa',
              name: 'Chapa (Card/Other)',
              icon: LucideIcons.creditCard,
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 64),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: selectedMethod == null ? null : () {
                _showPaymentDialog();
              },
              child: Text(L10n.get(lang, 'proceed_payment'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod({required String id, required String name, String? image, IconData? icon}) {
    final isSelected = selectedMethod == id;
    return GestureDetector(
      onTap: () => setState(() => selectedMethod = id),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        borderColor: isSelected ? AppColors.primary : AppColors.glassBorder,
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: image != null 
                ? Image.network(image, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(LucideIcons.wallet))
                : Icon(icon ?? LucideIcons.wallet, color: AppColors.textMain),
            ),
            const SizedBox(width: 16),
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(LucideIcons.checkCircle2, color: AppColors.primary, size: 24),
          ],
        ),
      ),
    );
  }

  void _showPaymentDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Text(L10n.get(ref.watch(languageProvider), 'confirm_identity'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textMain)),
              const SizedBox(height: 24),
              TextField(
                controller: _phoneController,
                style: const TextStyle(color: AppColors.textMain),
                decoration: InputDecoration(
                  hintText: L10n.get(ref.watch(languageProvider), 'enter_phone'),
                  hintStyle: const TextStyle(color: AppColors.textDim),
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _processPayment();
                },
                child: Text(L10n.get(ref.watch(languageProvider), 'confirm_pay'), style: const TextStyle(fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _processPayment() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      
      // Create and Save the Order
      final newOrder = ServiceOrder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        serviceName: widget.bankName,
        serviceCategory: 'Banking', // Could be dynamic
        customerPhone: _phoneController.text,
        orderDate: DateTime.now(),
        amountPaid: 50.0,
      );
      
      ref.read(ordersProvider.notifier).addOrder(newOrder);

      Navigator.pop(context); // Close loading
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SuccessScreen(bankName: widget.bankName)),
      );
    });
  }
}
