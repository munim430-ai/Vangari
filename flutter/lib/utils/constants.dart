class AppStrings {
  // App
  static const appName = 'ভাঙারি';
  static const appNameEn = 'Vangari';
  static const tagline = 'রিসাইকেল করুন, আয় করুন';
  static const taglineEn = 'Recycle smart, earn cash';

  // CTAs
  static const bookPickup = 'বিক্রি করুন';
  static const bookPickupEn = 'Book Pickup';
  static const confirmOrder = 'অর্ডার নিশ্চিত করুন';
  static const trackOrder = 'অর্ডার ট্র্যাক করুন';

  // Auth
  static const enterPhone = 'আপনার মোবাইল নম্বর দিন';
  static const enterPhoneEn = 'Enter your mobile number';
  static const enterOtp = 'OTP কোড দিন';
  static const sendOtp = 'OTP পাঠান';
  static const verifyOtp = 'যাচাই করুন';
  static const phoneHint = '+880 1X-XXXX-XXXX';

  // Navigation
  static const home = 'হোম';
  static const activity = 'অ্যাক্টিভিটি';
  static const wallet = 'ওয়ালেট';
  static const profile = 'প্রোফাইল';

  // Scrap categories
  static const paper = 'কাগজ';
  static const plastic = 'প্লাস্টিক';
  static const iron = 'লোহা';
  static const ewaste = 'ই-বর্জ্য';
  static const glass = 'কাচ';
  static const copper = 'তামা';
  static const aluminum = 'অ্যালুমিনিয়াম';
  static const rubber = 'রাবার';

  // Order status
  static const pending = 'অপেক্ষামান';
  static const assigned = 'নির্ধারিত';
  static const picked = 'সংগৃহীত';
  static const paid = 'পরিশোধিত';
  static const cancelled = 'বাতিল';

  // Support
  static const supportWhatsapp = '+8801700000000';
  static const supportNumber = '01700-000000';
}

class ScrapCategory {
  final String id;
  final String nameBn;
  final String nameEn;
  final String icon;
  final double pricePerKg;

  const ScrapCategory({
    required this.id,
    required this.nameBn,
    required this.nameEn,
    required this.icon,
    required this.pricePerKg,
  });
}

const kScrapCategories = [
  ScrapCategory(id: 'paper', nameBn: 'কাগজ', nameEn: 'Paper', icon: '📄', pricePerKg: 12),
  ScrapCategory(id: 'plastic', nameBn: 'প্লাস্টিক', nameEn: 'Plastic', icon: '🥤', pricePerKg: 18),
  ScrapCategory(id: 'iron', nameBn: 'লোহা', nameEn: 'Iron', icon: '🔩', pricePerKg: 35),
  ScrapCategory(id: 'ewaste', nameBn: 'ই-বর্জ্য', nameEn: 'E-waste', icon: '💻', pricePerKg: 80),
  ScrapCategory(id: 'glass', nameBn: 'কাচ', nameEn: 'Glass', icon: '🪟', pricePerKg: 8),
  ScrapCategory(id: 'copper', nameBn: 'তামা', nameEn: 'Copper', icon: '⚡', pricePerKg: 450),
  ScrapCategory(id: 'aluminum', nameBn: 'অ্যালুমিনিয়াম', nameEn: 'Aluminum', icon: '🥫', pricePerKg: 120),
  ScrapCategory(id: 'rubber', nameBn: 'রাবার', nameEn: 'Rubber', icon: '🔧', pricePerKg: 10),
];

const kDhakaAreas = [
  'ধানমন্ডি', 'গুলশান', 'বনানী', 'মিরপুর', 'উত্তরা',
  'মোহাম্মদপুর', 'লালবাগ', 'পুরান ঢাকা', 'বাড্ডা', 'রামপুরা',
  'মতিঝিল', 'পল্টন', 'ফার্মগেট', 'তেজগাঁও', 'খিলগাঁও',
];
