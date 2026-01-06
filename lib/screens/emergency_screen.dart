import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../utils/responsive.dart';

class EmergencyScreen extends ConsumerStatefulWidget {
  const EmergencyScreen({super.key});

  @override
  ConsumerState<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends ConsumerState<EmergencyScreen> {
  Map<String, String> _emergencyData = {
    'Name': 'Not Set',
    'Blood Type': '-',
    'Allergies': 'None',
    'Emergency Contact': '',
    'Medical Conditions': 'None'
  };

  bool _isEditing = false;
  bool _isLoading = true;
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _bloodController;
  late TextEditingController _allergiesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _contactController = TextEditingController();
    _bloodController = TextEditingController();
    _allergiesController = TextEditingController();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString('emergency_data');
    if (storedData != null) {
      setState(() {
        _emergencyData = Map<String, String>.from(json.decode(storedData));
      });
    }
    
    // Initialize controllers with loaded data
    _nameController.text = _emergencyData['Name'] ?? '';
    _contactController.text = _emergencyData['Emergency Contact'] ?? '';
    _bloodController.text = _emergencyData['Blood Type'] ?? '';
    _allergiesController.text = _emergencyData['Allergies'] ?? '';
    
    setState(() => _isLoading = false);
  }

  Future<void> _saveData() async {
    setState(() {
      _emergencyData['Name'] = _nameController.text;
      _emergencyData['Emergency Contact'] = _contactController.text;
      _emergencyData['Blood Type'] = _bloodController.text;
      _emergencyData['Allergies'] = _allergiesController.text;
      _isEditing = false;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('emergency_data', json.encode(_emergencyData));
  }

  Future<void> _makeEmergencyCall() async {
    final phoneNumber = _emergencyData['Emergency Contact'];
    if (phoneNumber == null || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No emergency contact set! Please edit your info.')),
      );
      return;
    }
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber.replaceAll(' ', ''));
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch dialer')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.redAccent)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('EMERGENCY ID', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w900, letterSpacing: 2)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(LucideIcons.x, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? LucideIcons.check : LucideIcons.edit2, color: Colors.white),
            onPressed: () {
              if (_isEditing) {
                _saveData();
              } else {
                setState(() => _isEditing = true);
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.responsive.horizontalPadding),
        child: Column(
          children: [
            SizedBox(height: context.responsive.getSpacing(20)),
            _buildQRSection(context),
            SizedBox(height: context.responsive.getSpacing(40)),
            _buildInfoSection(),
            SizedBox(height: context.responsive.getSpacing(30)),
            if (!_isEditing)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F), // Medical Red
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, context.responsive.buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.responsive.getBorderRadius(16))
                  ),
                ),
                icon: const Icon(LucideIcons.phoneCall),
                label: Text(
                  'CALL EMERGENCY CONTACT', 
                  style: TextStyle(
                    fontSize: context.responsive.getFontSize(16), 
                    fontWeight: FontWeight.bold
                  )
                ),
                onPressed: _makeEmergencyCall,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRSection(BuildContext context) {
    // Helper to format data string for QR
    String qrData = "EMERGENCY INFO:\n"
        "Name: ${_emergencyData['Name']}\n"
        "Blood: ${_emergencyData['Blood Type']}\n"
        "Allergies: ${_emergencyData['Allergies']}\n"
        "Contact: ${_emergencyData['Emergency Contact']}";

    final qrSize = context.responsive.qrCodeSize;

    return Column(
      children: [
        Container(
          width: qrSize,
          height: qrSize,
          padding: EdgeInsets.all(context.responsive.getSpacing(12)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(context.responsive.getBorderRadius(24)),
            boxShadow: [
              BoxShadow(color: Colors.redAccent.withValues(alpha: 0.4), blurRadius: 30, spreadRadius: 5),
            ],
          ),
          child: Center(
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: qrSize - (context.responsive.getSpacing(12) * 2) - 20,
              backgroundColor: Colors.white,
            ),
          ),
        ),
        SizedBox(height: context.responsive.getSpacing(16)),
        Text(
          'Scan for Medical Info',
          style: TextStyle(
            color: Colors.white70, 
            fontSize: context.responsive.getFontSize(13), 
            letterSpacing: 1
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    if (_isEditing) {
      return Column(
        children: [
          _buildTextField('Full Name', _nameController),
          const SizedBox(height: 16),
          _buildTextField('Blood Type', _bloodController),
          const SizedBox(height: 16),
          _buildTextField('Allergies', _allergiesController),
          const SizedBox(height: 16),
          _buildTextField('Emergency Contact', _contactController, isPhone: true),
        ],
      );
    }

    return Column(
      children: _emergencyData.entries.map((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GlassCard(
            gradientColors: [Colors.white.withValues(alpha: 0.05), Colors.white.withValues(alpha: 0.05)],
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  e.key.toUpperCase(),
                  style: TextStyle(color: Colors.redAccent.shade100, fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Text(
                  e.value,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isPhone = false}) {
    return TextField(
      controller: controller,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.redAccent)),
      ),
    );
  }
}
