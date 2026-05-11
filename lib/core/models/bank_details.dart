class BankDetails {
  String accountName;
  String accountNo;
  String bankName;
  String branchCode;

  BankDetails({
    required this.accountName,
    required this.accountNo,
    required this.bankName,
    required this.branchCode,
  });

  Map<String, dynamic> toMap() => {
        'accountName': accountName,
        'accountNo': accountNo,
        'bankName': bankName,
        'branchCode': branchCode,
      };

  factory BankDetails.fromMap(Map<String, dynamic> map) => BankDetails(
        accountName: map['accountName'] ?? '',
        accountNo: map['accountNo'] ?? '',
        bankName: map['bankName'] ?? '',
        branchCode: map['branchCode'] ?? '',
      );
}
