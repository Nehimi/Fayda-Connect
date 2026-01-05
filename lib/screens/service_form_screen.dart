import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/service_model.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import 'payment_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import '../providers/user_provider.dart';
import '../providers/order_provider.dart';
import '../models/order_model.dart';
import 'success_screen.dart';

class ServiceFormScreen extends ConsumerStatefulWidget {
  final String serviceName;
  final String category;
  const ServiceFormScreen({super.key, required this.serviceName, required this.category});

  @override
  ConsumerState<ServiceFormScreen> createState() => _ServiceFormScreenState();
}

class _ServiceFormScreenState extends ConsumerState<ServiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    // Initialize common controllers
    _controllers['fullName'] = TextEditingController();
    _controllers['phone'] = TextEditingController();
    _controllers['faydaId'] = TextEditingController();
    
    // Category specific controllers
    if (widget.category == 'Passport') {
      _controllers['passportNumber'] = TextEditingController();
    } else if (widget.category == 'Business') {
      _controllers['tin'] = TextEditingController();
      _controllers['businessName'] = TextEditingController();
    } else if (widget.category == 'Banking') {
      _controllers['accountNumber'] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final user = ref.watch(userProvider);
    
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(widget.serviceName),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Application Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textMain),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please fill in the following information to start your application.',
                style: TextStyle(color: AppColors.textDim, fontSize: 16),
              ),
              const SizedBox(height: 32),
              
              _buildTextField(LucideIcons.user, 'Full Name (as per ID)', 'fullName'),
              _buildTextField(
                LucideIcons.phone, 
                widget.category == 'Banking' ? 'Phone Number (Linked to Bank)' : 'Phone Number', 
                'phone', 
                keyboardType: TextInputType.phone
              ),
              _buildTextField(LucideIcons.fingerprint, 'Fayda ID Number', 'faydaId', keyboardType: TextInputType.number),
              
              if (widget.category == 'Passport') ...[
                const SizedBox(height: 16),
                const Divider(color: AppColors.glassBorder),
                const SizedBox(height: 16),
                _buildTextField(LucideIcons.hash, 'Existing Passport Number (Optional)', 'passportNumber'),
              ],
              
              if (widget.category == 'Business') ...[
                const SizedBox(height: 16),
                const Divider(color: AppColors.glassBorder),
                const SizedBox(height: 16),
                _buildTextField(LucideIcons.building, 'Business Name', 'businessName'),
                _buildTextField(LucideIcons.hash, 'TIN Number', 'tin'),
              ],

              if (widget.category == 'Banking') ...[
                const SizedBox(height: 16),
                const Divider(color: AppColors.glassBorder),
                const SizedBox(height: 16),
                _buildTextField(LucideIcons.creditCard, 'Bank Account Number', 'accountNumber', keyboardType: TextInputType.number),
              ],
              
              const SizedBox(height: 48),
              
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 64),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final formData = _controllers.map((key, controller) => MapEntry(key, controller.text));
                    
                    if (user.isPremium) {
                      // Premium Logic: Skip Payment
                      final newOrder = ServiceOrder(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        serviceName: widget.serviceName,
                        serviceCategory: widget.category,
                        customerPhone: _controllers['phone']!.text,
                        orderDate: DateTime.now(),
                        amountPaid: 0.0,
                        formData: formData,
                        status: OrderStatus.processing, // Or pending
                      );
                      
                      ref.read(ordersProvider.notifier).addOrder(newOrder);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SuccessScreen(bankName: widget.serviceName)),
                      );
                    } else {
                      // Standard Logic: Go to Payment
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                            bankName: widget.serviceName,
                            formData: formData,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Text(
                  user.isPremium 
                    ? (lang == AppLanguage.english ? 'Submit Application' : 'ማመልከቻውን አስገባ') 
                    : (lang == AppLanguage.english ? 'Continue to Payment' : 'ወደ ክፍያ ይቀጥሉ'),
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String label, String controllerKey, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          TextFormField(
            controller: _controllers[controllerKey],
            keyboardType: keyboardType,
            style: const TextStyle(color: AppColors.textMain),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 20, color: AppColors.primary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.glassBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                if (label.contains('Optional')) return null;
                return 'Please enter $label';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
