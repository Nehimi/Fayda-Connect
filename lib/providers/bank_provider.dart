import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bank_model.dart';

final bankListProvider = Provider<List<BankService>>((ref) {
  return [
    BankService(
      id: 'cbe',
      name: 'Commercial Bank of Ethiopia (CBE)',
      logo: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6-6R7kGkF_-YgT_e3G0Iit9o7yq8XoO8Cqw&s',
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
      logo: 'https://pbs.twimg.com/profile_images/1648937748437942273/9GvX3Kqf_400x400.jpg',
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
      logo: 'https://play-lh.googleusercontent.com/B9BofpE_iVqRkP-AAnreDORm06m1_I0_9H0xGj14zR-iL7C_FvK9vXy3X_q5v-iH8r-U=w240-h480-rw',
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
