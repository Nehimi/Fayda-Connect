import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bank_model.dart';

final bankListProvider = Provider<List<Bank>>((ref) {
  return [
    Bank(
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
    Bank(
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
    Bank(
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
    Bank(
      id: 'awash',
      name: 'Awash Bank',
      logo: 'https://api.dicebear.com/7.x/initials/png?seed=Awash&backgroundColor=10b981',
      type: BankType.online,
      officialLink: 'https://www.awashbank.com',
      instructionSteps: [
        'Visit Awash Bank portal',
        'Login with your account credentials',
        'Navigate to KYC section',
        'Enter your Fayda FIN',
        'Complete verification'
      ],
      requirements: ['Awash Account', 'Fayda ID', 'Phone Number'],
    ),
    Bank(
      id: 'wegagen',
      name: 'Wegagen Bank',
      logo: 'https://api.dicebear.com/7.x/initials/png?seed=Wegagen&backgroundColor=f59e0b',
      type: BankType.online,
      officialLink: 'https://www.wegagen.com',
      instructionSteps: [
        'Access Wegagen online banking',
        'Go to Profile Settings',
        'Select "Link National ID"',
        'Enter your 12-digit FIN',
        'Verify with OTP'
      ],
      requirements: ['Wegagen Account', 'Fayda ID', 'Mobile Number'],
    ),
    Bank(
      id: 'united',
      name: 'United Bank',
      logo: 'https://api.dicebear.com/7.x/initials/png?seed=United&backgroundColor=ec4899',
      type: BankType.online,
      officialLink: 'https://www.unitedbank.com.et',
      instructionSteps: [
        'Login to United Bank portal',
        'Select "Update KYC"',
        'Provide Fayda ID details',
        'Submit for verification'
      ],
      requirements: ['United Account', 'Fayda ID'],
    ),
    Bank(
      id: 'nib',
      name: 'Nib International Bank',
      logo: 'https://api.dicebear.com/7.x/initials/png?seed=NIB&backgroundColor=8b5cf6',
      type: BankType.online,
      officialLink: 'https://www.nibbanksc.com',
      instructionSteps: [
        'Visit Nib Bank website',
        'Access customer portal',
        'Link your Fayda ID',
        'Complete biometric verification if required'
      ],
      requirements: ['Nib Account', 'Fayda ID', 'Biometric Data'],
    ),
    Bank(
      id: 'coop',
      name: 'Cooperative Bank of Oromia',
      logo: 'https://api.dicebear.com/7.x/initials/png?seed=COOP&backgroundColor=06b6d4',
      type: BankType.online,
      officialLink: 'https://www.coopbankoromia.com.et',
      instructionSteps: [
        'Open Coop Bank portal',
        'Navigate to ID Linking',
        'Enter Fayda FIN',
        'Confirm with SMS OTP'
      ],
      requirements: ['Coop Account', 'Fayda ID', 'Phone Number'],
    ),
    Bank(
      id: 'oromia',
      name: 'Oromia Bank',
      logo: 'https://api.dicebear.com/7.x/initials/png?seed=Oromia&backgroundColor=ef4444',
      type: BankType.online,
      officialLink: 'https://www.oromiabank.com',
      instructionSteps: [
        'Login to Oromia Bank',
        'Go to Settings',
        'Select "National ID Linking"',
        'Enter your FIN',
        'Verify identity'
      ],
      requirements: ['Oromia Account', 'Fayda ID'],
    ),
    Bank(
      id: 'lion',
      name: 'Lion International Bank',
      logo: 'https://api.dicebear.com/7.x/initials/png?seed=Lion&backgroundColor=f97316',
      type: BankType.online,
      officialLink: 'https://www.lionbank.com.et',
      instructionSteps: [
        'Access Lion Bank portal',
        'Select KYC Update',
        'Link Fayda ID',
        'Complete verification process'
      ],
      requirements: ['Lion Account', 'Fayda ID', 'Phone Number'],
    ),
    Bank(
      id: 'zemen',
      name: 'Zemen Bank',
      logo: 'https://api.dicebear.com/7.x/initials/png?seed=Zemen&backgroundColor=14b8a6',
      type: BankType.online,
      officialLink: 'https://www.zemenbank.com',
      instructionSteps: [
        'Visit Zemen Bank website',
        'Login to your account',
        'Navigate to Profile',
        'Add Fayda ID',
        'Verify with OTP'
      ],
      requirements: ['Zemen Account', 'Fayda ID'],
    ),
    Bank(
      id: 'bunna',
      name: 'Bunna International Bank',
      logo: 'https://api.dicebear.com/7.x/initials/png?seed=Bunna&backgroundColor=a855f7',
      type: BankType.online,
      officialLink: 'https://www.bunnabanksc.com',
      instructionSteps: [
        'Open Bunna Bank portal',
        'Go to Account Settings',
        'Link National ID',
        'Submit Fayda FIN'
      ],
      requirements: ['Bunna Account', 'Fayda ID'],
    ),
    Bank(
      id: 'berhan',
      name: 'Berhan Bank',
      logo: 'https://api.dicebear.com/7.x/initials/png?seed=Berhan&backgroundColor=eab308',
      type: BankType.online,
      officialLink: 'https://www.berhanbank.com',
      instructionSteps: [
        'Login to Berhan Bank',
        'Select "Update Information"',
        'Enter Fayda ID details',
        'Complete verification'
      ],
      requirements: ['Berhan Account', 'Fayda ID'],
    ),
    Bank(
      id: 'enat',
      name: 'Enat Bank',
      logo: 'https://api.dicebear.com/7.x/initials/png?seed=Enat&backgroundColor=84cc16',
      type: BankType.online,
      officialLink: 'https://www.enatbanksc.com',
      instructionSteps: [
        'Access Enat Bank portal',
        'Navigate to KYC section',
        'Link your Fayda ID',
        'Verify with OTP'
      ],
      requirements: ['Enat Account', 'Fayda ID', 'Phone Number'],
    ),
    Bank(
      id: 'addis',
      name: 'Addis International Bank',
      logo: 'https://api.dicebear.com/7.x/initials/png?seed=Addis&backgroundColor=3b82f6',
      type: BankType.online,
      officialLink: 'https://www.addisbank.com',
      instructionSteps: [
        'Visit Addis Bank website',
        'Login to online banking',
        'Go to Profile Settings',
        'Add Fayda FIN',
        'Complete verification'
      ],
      requirements: ['Addis Account', 'Fayda ID'],
    ),
    Bank(
      id: 'hijra',
      name: 'Hijra Bank',
      logo: 'https://api.dicebear.com/7.x/initials/png?seed=Hijra&backgroundColor=22c55e',
      type: BankType.online,
      officialLink: 'https://www.hijrabank.com.et',
      instructionSteps: [
        'Open Hijra Bank portal',
        'Select "Link National ID"',
        'Enter your Fayda FIN',
        'Submit for verification'
      ],
      requirements: ['Hijra Account', 'Fayda ID'],
    ),
    Bank(
      id: 'tsehay',
      name: 'Tsehay Bank',
      logo: 'https://api.dicebear.com/7.x/initials/png?seed=Tsehay&backgroundColor=f43f5e',
      type: BankType.online,
      officialLink: 'https://www.tsehaybank.com.et',
      instructionSteps: [
        'Login to Tsehay Bank',
        'Navigate to Account Settings',
        'Link Fayda ID',
        'Verify with SMS code'
      ],
      requirements: ['Tsehay Account', 'Fayda ID', 'Phone Number'],
    ),
    Bank(
      id: 'shabelle',
      name: 'Shabelle Bank',
      logo: 'https://api.dicebear.com/7.x/initials/png?seed=Shabelle&backgroundColor=0ea5e9',
      type: BankType.online,
      officialLink: 'https://www.shabellebank.com.et',
      instructionSteps: [
        'Access Shabelle Bank portal',
        'Go to KYC Update',
        'Enter Fayda ID',
        'Complete verification process'
      ],
      requirements: ['Shabelle Account', 'Fayda ID'],
    ),
    Bank(
      id: 'gadaa',
      name: 'Gadaa Bank',
      logo: 'https://api.dicebear.com/7.x/initials/png?seed=Gadaa&backgroundColor=fb923c',
      type: BankType.online,
      officialLink: 'https://www.gadaabank.com.et',
      instructionSteps: [
        'Visit Gadaa Bank website',
        'Login to your account',
        'Select "Link National ID"',
        'Enter your 12-digit FIN',
        'Verify with OTP'
      ],
      requirements: ['Gadaa Account', 'Fayda ID', 'Mobile Number'],
    ),
  ];
});
