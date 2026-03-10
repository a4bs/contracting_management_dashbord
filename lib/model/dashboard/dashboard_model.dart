class TotalBalance {
  String? totalBillsDebit;
  String? totalBondDebit;
  String? totalBondCredit;
  String? balance;

  TotalBalance({
    this.totalBillsDebit,
    this.totalBondDebit,
    this.totalBondCredit,
    this.balance,
  });

  TotalBalance.fromJson(Map<String, dynamic> json) {
    totalBillsDebit = json['total_bills_debit'].toString();
    totalBondDebit = json['total_bond_debit'].toString();
    totalBondCredit = json['total_bond_credit'].toString();
    balance = json['balance'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_bills_debit'] = totalBillsDebit;
    data['total_bond_debit'] = totalBondDebit;
    data['total_bond_credit'] = totalBondCredit;
    data['balance'] = balance;
    return data;
  }
}

class BoxDashboardModel {
  String? totalBoxes;

  BoxDashboardModel({this.totalBoxes});

  BoxDashboardModel.fromJson(Map<String, dynamic> json) {
    totalBoxes = json['total_boxes'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_boxes'] = totalBoxes;
    return data;
  }
}

class CustomerDashboardModel {
  String? totalCustomers;

  CustomerDashboardModel({this.totalCustomers});

  CustomerDashboardModel.fromJson(Map<String, dynamic> json) {
    totalCustomers = json['total_customers'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_customers'] = totalCustomers;
    return data;
  }
}

class UnitDashboardModel {
  String? totalUnits;

  UnitDashboardModel({this.totalUnits});

  UnitDashboardModel.fromJson(Map<String, dynamic> json) {
    totalUnits = json['total_units'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_units'] = totalUnits;
    return data;
  }
}

class UserDashboardModel {
  String? totalUsers;

  UserDashboardModel({this.totalUsers});

  UserDashboardModel.fromJson(Map<String, dynamic> json) {
    totalUsers = json['total_users'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_users'] = totalUsers;
    return data;
  }
}

class ProjectDashboardModel {
  String? totalProjects;

  ProjectDashboardModel({this.totalProjects});

  ProjectDashboardModel.fromJson(Map<String, dynamic> json) {
    totalProjects = json['total_projects'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_projects'] = totalProjects;
    return data;
  }
}

class DebitCustomersDashboardModel {
  String? debitCustomersCount;

  DebitCustomersDashboardModel({this.debitCustomersCount});

  DebitCustomersDashboardModel.fromJson(Map<String, dynamic> json) {
    debitCustomersCount = json['debit_customers_count'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['debit_customers_count'] = debitCustomersCount;
    return data;
  }
}

class DebitCreditBalanceModel {
  String? debit;
  String? credit;

  DebitCreditBalanceModel({this.debit, this.credit});

  DebitCreditBalanceModel.fromJson(Map<String, dynamic> json) {
    debit = json['debit'].toString();
    credit = json['credit'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['debit'] = debit;
    data['credit'] = credit;
    return data;
  }
}
