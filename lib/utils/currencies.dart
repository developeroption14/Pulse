class Currency {
  final String code;
  final String symbol;
  final String name;
  final String country;

  const Currency({
    required this.code,
    required this.symbol,
    required this.name,
    required this.country,
  });
}

const List<Currency> kCurrencies = [
  // ═══════════ MOST USED (top) ═══════════
  Currency(code: 'USD', symbol: '\$', name: 'US Dollar', country: 'United States'),
  Currency(code: 'BDT', symbol: '৳', name: 'Bangladeshi Taka', country: 'Bangladesh'),
  Currency(code: 'INR', symbol: '₹', name: 'Indian Rupee', country: 'India'),
  Currency(code: 'EUR', symbol: '€', name: 'Euro', country: 'European Union'),
  Currency(code: 'GBP', symbol: '£', name: 'British Pound', country: 'United Kingdom'),
  
  // ═══════════ ASIA ═══════════
  Currency(code: 'PKR', symbol: '₨', name: 'Pakistani Rupee', country: 'Pakistan'),
  Currency(code: 'LKR', symbol: 'Rs', name: 'Sri Lankan Rupee', country: 'Sri Lanka'),
  Currency(code: 'NPR', symbol: '₨', name: 'Nepalese Rupee', country: 'Nepal'),
  Currency(code: 'CNY', symbol: '¥', name: 'Chinese Yuan', country: 'China'),
  Currency(code: 'JPY', symbol: '¥', name: 'Japanese Yen', country: 'Japan'),
  Currency(code: 'KRW', symbol: '₩', name: 'South Korean Won', country: 'South Korea'),
  Currency(code: 'THB', symbol: '฿', name: 'Thai Baht', country: 'Thailand'),
  Currency(code: 'MYR', symbol: 'RM', name: 'Malaysian Ringgit', country: 'Malaysia'),
  Currency(code: 'SGD', symbol: 'S\$', name: 'Singapore Dollar', country: 'Singapore'),
  Currency(code: 'IDR', symbol: 'Rp', name: 'Indonesian Rupiah', country: 'Indonesia'),
  Currency(code: 'PHP', symbol: '₱', name: 'Philippine Peso', country: 'Philippines'),
  Currency(code: 'VND', symbol: '₫', name: 'Vietnamese Dong', country: 'Vietnam'),
  Currency(code: 'HKD', symbol: 'HK\$', name: 'Hong Kong Dollar', country: 'Hong Kong'),
  Currency(code: 'TWD', symbol: 'NT\$', name: 'Taiwan Dollar', country: 'Taiwan'),
  
  // ═══════════ MIDDLE EAST ═══════════
  Currency(code: 'AED', symbol: 'د.إ', name: 'UAE Dirham', country: 'UAE'),
  Currency(code: 'SAR', symbol: '﷼', name: 'Saudi Riyal', country: 'Saudi Arabia'),
  Currency(code: 'QAR', symbol: '﷼', name: 'Qatari Riyal', country: 'Qatar'),
  Currency(code: 'KWD', symbol: 'د.ك', name: 'Kuwaiti Dinar', country: 'Kuwait'),
  Currency(code: 'BHD', symbol: '.د.ب', name: 'Bahraini Dinar', country: 'Bahrain'),
  Currency(code: 'OMR', symbol: '﷼', name: 'Omani Rial', country: 'Oman'),
  Currency(code: 'JOD', symbol: 'د.ا', name: 'Jordanian Dinar', country: 'Jordan'),
  Currency(code: 'ILS', symbol: '₪', name: 'Israeli Shekel', country: 'Israel'),
  Currency(code: 'TRY', symbol: '₺', name: 'Turkish Lira', country: 'Turkey'),
  Currency(code: 'IRR', symbol: '﷼', name: 'Iranian Rial', country: 'Iran'),
  
  // ═══════════ AFRICA ═══════════
  Currency(code: 'EGP', symbol: 'E£', name: 'Egyptian Pound', country: 'Egypt'),
  Currency(code: 'ZAR', symbol: 'R', name: 'South African Rand', country: 'South Africa'),
  Currency(code: 'NGN', symbol: '₦', name: 'Nigerian Naira', country: 'Nigeria'),
  Currency(code: 'KES', symbol: 'KSh', name: 'Kenyan Shilling', country: 'Kenya'),
  Currency(code: 'GHS', symbol: '₵', name: 'Ghanaian Cedi', country: 'Ghana'),
  Currency(code: 'MAD', symbol: 'د.م.', name: 'Moroccan Dirham', country: 'Morocco'),
  Currency(code: 'TND', symbol: 'د.ت', name: 'Tunisian Dinar', country: 'Tunisia'),
  Currency(code: 'ETB', symbol: 'Br', name: 'Ethiopian Birr', country: 'Ethiopia'),
  
  // ═══════════ AMERICAS ═══════════
  Currency(code: 'CAD', symbol: 'C\$', name: 'Canadian Dollar', country: 'Canada'),
  Currency(code: 'MXN', symbol: 'Mex\$', name: 'Mexican Peso', country: 'Mexico'),
  Currency(code: 'BRL', symbol: 'R\$', name: 'Brazilian Real', country: 'Brazil'),
  Currency(code: 'ARS', symbol: '\$', name: 'Argentine Peso', country: 'Argentina'),
  Currency(code: 'CLP', symbol: '\$', name: 'Chilean Peso', country: 'Chile'),
  Currency(code: 'COP', symbol: '\$', name: 'Colombian Peso', country: 'Colombia'),
  Currency(code: 'PEN', symbol: 'S/', name: 'Peruvian Sol', country: 'Peru'),
  
  // ═══════════ EUROPE ═══════════
  Currency(code: 'CHF', symbol: 'Fr', name: 'Swiss Franc', country: 'Switzerland'),
  Currency(code: 'SEK', symbol: 'kr', name: 'Swedish Krona', country: 'Sweden'),
  Currency(code: 'NOK', symbol: 'kr', name: 'Norwegian Krone', country: 'Norway'),
  Currency(code: 'DKK', symbol: 'kr', name: 'Danish Krone', country: 'Denmark'),
  Currency(code: 'PLN', symbol: 'zł', name: 'Polish Zloty', country: 'Poland'),
  Currency(code: 'CZK', symbol: 'Kč', name: 'Czech Koruna', country: 'Czech Republic'),
  Currency(code: 'HUF', symbol: 'Ft', name: 'Hungarian Forint', country: 'Hungary'),
  Currency(code: 'RON', symbol: 'lei', name: 'Romanian Leu', country: 'Romania'),
  Currency(code: 'RUB', symbol: '₽', name: 'Russian Ruble', country: 'Russia'),
  Currency(code: 'UAH', symbol: '₴', name: 'Ukrainian Hryvnia', country: 'Ukraine'),
  
  // ═══════════ OCEANIA ═══════════
  Currency(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar', country: 'Australia'),
  Currency(code: 'NZD', symbol: 'NZ\$', name: 'New Zealand Dollar', country: 'New Zealand'),
];

/// Get currency by code (defaults to USD)
Currency getCurrencyByCode(String code) {
  return kCurrencies.firstWhere(
    (c) => c.code == code,
    orElse: () => kCurrencies.first, // USD
  );
}

/// Default currency
const Currency kDefaultCurrency = Currency(
  code: 'USD',
  symbol: '\$',
  name: 'US Dollar',
  country: 'United States',
);