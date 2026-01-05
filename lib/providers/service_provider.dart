import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/service_model.dart';

final passportServiceProvider = Provider<List<GeneralService>>((ref) {
  return [
    GeneralService(
      id: 'pass_new',
      category: 'Passport',
      name: 'New Passport Application',
      description: 'Apply for your first electronic passport using Fayda ID.',
      logo: 'https://cdn-icons-png.flaticon.com/512/3201/3201111.png',
      type: ServiceType.online,
      officialLink: 'https://www.passport.gov.et',
      instructionSteps: [
        'Get your 12-digit FIN from your Fayda ID card.',
        'Visit the official INAS portal.',
        'Select "New Passport" and enter your FIN.',
        'Choose your appointment date and office location.',
        'Pay the fee via Telebirr or CBE Birr.',
        'Print your appointment slip.'
      ],
      requirements: ['Fayda FIN', 'Birth Certificate', 'Telebirr/CBE Birr', 'Appointment Slip'],
      assistanceFee: 100.0,
    ),
    GeneralService(
      id: 'pass_renew',
      category: 'Passport',
      name: 'Passport Renewal',
      description: 'Renew your expiring passport with your digital ID.',
      logo: 'https://cdn-icons-png.flaticon.com/512/3201/3201111.png',
      type: ServiceType.online,
      officialLink: 'https://www.passport.gov.et',
      instructionSteps: [
        'Login to the INAS portal.',
        'Enter your old passport number and Fayda FIN.',
        'Upload a digital photo if required.',
        'Pay the renewal fee.',
        'Schedule your biometric data collection.'
      ],
      requirements: ['Old Passport', 'Fayda ID', 'Digital Photo'],
      assistanceFee: 100.0,
    ),
  ];
});

final educationServiceProvider = Provider<List<GeneralService>>((ref) {
  return [
    GeneralService(
      id: 'edu_exam',
      category: 'Education',
      name: 'Grade 12 Exam Registration',
      description: 'Link your Fayda ID to your national exam registration.',
      logo: 'https://cdn-icons-png.flaticon.com/512/2997/2997313.png',
      type: ServiceType.online,
      officialLink: 'https://eaes.et',
      instructionSteps: [
        'Go to the EAES registration portal.',
        'Select Student Registration.',
        'Enter your school code and Fayda FIN.',
        'Verify your personal details against the NID database.',
        'Confirm and submit.'
      ],
      requirements: ['School Code', 'Fayda ID', 'Grade 11 Results'],
    ),
    GeneralService(
      id: 'edu_uni',
      category: 'Education',
      name: 'University Admission Link',
      description: 'Link Fayda ID for university placement and student ID.',
      logo: 'https://cdn-icons-png.flaticon.com/512/2997/2997313.png',
      type: ServiceType.online,
      instructionSteps: [
        'Register on the Ministry of Education student portal.',
        'Provide your Fayda FIN for identity verification.',
        'Wait for placement notification based on your verified data.'
      ],
      requirements: ['Grade 12 Result', 'Fayda ID'],
    ),
  ];
});

final businessServiceProvider = Provider<List<GeneralService>>((ref) {
  return [
    GeneralService(
      id: 'biz_tin',
      category: 'Business',
      name: 'TIN Registration',
      description: 'Get your Taxpayer Identification Number using Fayda.',
      logo: 'https://cdn-icons-png.flaticon.com/512/3135/3135706.png',
      type: ServiceType.online,
      officialLink: 'https://etrade.gov.et',
      instructionSteps: [
        'Access the e-Trade portal.',
        'Select "New TIN Registration".',
        'Use Fayda ID for electronic signature and verification.',
        'Fill in business details.',
        'Submit for digital certificate issuance.'
      ],
      requirements: ['Fayda ID', 'Business Address', 'Phone Number'],
      assistanceFee: 150.0,
    ),
    GeneralService(
      id: 'biz_license',
      category: 'Business',
      name: 'Business License Renewal',
      description: 'Renew your trade license with Fayda verification.',
      logo: 'https://cdn-icons-png.flaticon.com/512/3135/3135706.png',
      type: ServiceType.online,
      instructionSteps: [
        'Login to Ministry of Trade portal.',
        'Link your Fayda ID to your existing profile.',
        'Pay renewal fees via Telebirr.',
        'Download your renewed digital license.'
      ],
      requirements: ['Existing License', 'Fayda ID', 'Tax Clearance'],
      assistanceFee: 200.0,
    ),
  ];
});

final publicServiceServiceProvider = Provider<List<GeneralService>>((ref) {
  return [
    GeneralService(
      id: 'pub_driver',
      category: 'Public Service',
      name: 'Driver License Renewal',
      description: 'Renew your driving license digitally using Fayda identity.',
      logo: 'https://cdn-icons-png.flaticon.com/512/2554/2554930.png',
      type: ServiceType.online,
      instructionSteps: [
        'Go to the Transport Authority digital portal.',
        'Validate your identity with Fayda ID.',
        'Submit medical certificate digital copy.',
        'Pay the renewal fee.',
        'Pick up your license or request delivery.'
      ],
      requirements: ['Expired License', 'Medical Certificate', 'Fayda ID'],
      assistanceFee: 50.0,
    ),
    GeneralService(
      id: 'pub_sim',
      category: 'Telecom',
      name: 'SIM Card Re-registration',
      description: 'Link your Ethio Telecom or Safaricom SIM to Fayda.',
      logo: 'https://cdn-icons-png.flaticon.com/512/3415/3415077.png',
      type: ServiceType.online,
      instructionSteps: [
        'Dial *804# or visit mobile operator app.',
        'Enter your 12-digit Fayda FIN.',
        'Upload a photo of your Fayda card if requested.',
        'Receive confirmation SMS.'
      ],
      requirements: ['Active SIM', 'Fayda ID', '12-digit FIN'],
      assistanceFee: 20.0,
    ),
    GeneralService(
      id: 'pub_vital',
      category: 'Vital Events',
      name: 'Birth Certificate Sync',
      description: 'Link your birth certificate to Fayda for digital authentication.',
      logo: 'https://cdn-icons-png.flaticon.com/512/3209/3209224.png',
      type: ServiceType.inPerson,
      instructionSteps: [
        'Visit your local Woreda Vital Events office.',
        'Present your physical Fayda ID card.',
        'Provide your registered birth certificate number.',
        'Verify biometrics on the agent device.'
      ],
      requirements: ['Physical ID', 'Birth Certificate', 'Woreda Appointment'],
      assistanceFee: 150.0,
    ),
  ];
});
