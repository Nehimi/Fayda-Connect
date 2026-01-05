import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bank_model.dart';

final bankListProvider = Provider<List<BankService>>((ref) {
  return [
    BankService(
      id: 'cbe',
      name: 'Commercial Bank of Ethiopia (CBE)',
      logo: 'https://api.dicebear.com/7.x/initials/png?seed=CBE&backgroundColor=6366f1',
      type: BankType.online,
      officialLink: 'https://kyc.cbe.com.et',
      instructionSteps: [
        'Visit kyc.cbe.com.et',
        'Enter your CBE Account Number',
        'Enter the OTP sent to your phone',
        'Enter your Fayda Identification Number (FIN)',
        'Submit and wait for confirmation'
      ],
      requirements: ['CBE Account', 'Fayda ID', 'Active Phone Number'],
    ),
    BankService(
      id: 'boa',
      name: 'Bank of Abyssinia',
      logo: 'https://api.dicebear.com/7.x/initials/png?seed=BOA&backgroundColor=b6e3f4',
      type: BankType.online,
      officialLink: 'https://faydaconnect.bankofabyssinia.com',
      instructionSteps: [
        'Open the Abyssinia Fayda Connect portal',
        'Provide your Account number',
        'Perform Liveness check if required',
        'Link your FIN to your account'
      ],
      requirements: ['BoA Account', 'Fayda ID', 'Camera for Liveness'],
    ),
    BankService(
      id: 'dashen',
      name: 'Dashen Bank',
      logo: 'https://api.dicebear.com/7.x/initials/png?seed=Dashen&backgroundColor=ffd5dc',
      type: BankType.online,
      officialLink: 'https://fayda.dashenbanksc.com',
      instructionSteps: [
        'Go to Dashen Fayda Portal',
        'Enter your Mobile number linked to Amole',
        'Input the OTP received',
        'Link your Digital ID'
      ],
      requirements: ['Dashen/Amole Mobile Number', 'Fayda ID'],
    ),
    // More banks can be added here
  ];
});
