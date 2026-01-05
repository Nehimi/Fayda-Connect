import 'dart:math';
import 'package:flutter/material.dart';
import '../models/digital_id.dart';
import '../theme/colors.dart';

class ThreeDDigitalCard extends StatefulWidget {
  final DigitalID id;
  const ThreeDDigitalCard({super.key, required this.id});

  @override
  State<ThreeDDigitalCard> createState() => _ThreeDDigitalCardState();
}

class _ThreeDDigitalCardState extends State<ThreeDDigitalCard> {
  double xRotation = 0;
  double yRotation = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          yRotation += details.delta.dx / 100;
          xRotation -= details.delta.dy / 100;
          // Limit rotation
          xRotation = xRotation.clamp(-0.5, 0.5);
          yRotation = yRotation.clamp(-0.5, 0.5);
        });
      },
      onPanEnd: (details) {
        setState(() {
          xRotation = 0;
          yRotation = 0;
        });
      },
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // perspective
          ..rotateX(xRotation)
          ..rotateY(yRotation),
        alignment: FractionalOffset.center,
        child: Container(
          width: double.infinity,
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1E293B),
                Color(0xFF0F172A),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned(
                right: -50,
                top: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.05),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'FEDERAL DEMOCRATIC REPUBLIC\nOF ETHIOPIA',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                          ),
                        ),
                        Container(
                          width: 30,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            image: const DecorationImage(
                              image: NetworkImage('https://flagcdn.com/w80/et.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: const DecorationImage(
                              image: NetworkImage('https://api.dicebear.com/7.x/avataaars/png?seed=Abebe'),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(color: Colors.white24),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.id.fullName.toUpperCase(),
                                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'FIN: ${widget.id.fin}',
                                style: const TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildInfo('DOB', widget.id.dob),
                                  const SizedBox(width: 20),
                                  _buildInfo('GENDER', widget.id.gender),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfo('EXPIRES', widget.id.expiryDate),
                        const Icon(Icons.qr_code_2, color: Colors.white70, size: 40),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
