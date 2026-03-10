class OwnerDashboardModel {
  PlatformOverview? platformOverview;
  GrowthMetrics? growthMetrics;
  FinancialReport? financialReport;
  ResourceUsage? resourceUsage;
  Operations? operations;
  UserRoles? userRoles;
  String? generatedAt;

  OwnerDashboardModel({
    this.platformOverview,
    this.growthMetrics,
    this.financialReport,
    this.resourceUsage,
    this.operations,
    this.userRoles,
    this.generatedAt,
  });

  OwnerDashboardModel.fromJson(Map<String, dynamic> json) {
    platformOverview = json['platform_overview'] != null
        ? PlatformOverview.fromJson(json['platform_overview'])
        : null;
    growthMetrics = json['growth_metrics'] != null
        ? GrowthMetrics.fromJson(json['growth_metrics'])
        : null;
    financialReport = json['financial_report'] != null
        ? FinancialReport.fromJson(json['financial_report'])
        : null;
    resourceUsage = json['resource_usage'] != null
        ? ResourceUsage.fromJson(json['resource_usage'])
        : null;
    operations = json['operations'] != null
        ? Operations.fromJson(json['operations'])
        : null;
    userRoles = json['user_roles'] != null
        ? UserRoles.fromJson(json['user_roles'])
        : null;
    generatedAt = json['generated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (platformOverview != null) {
      data['platform_overview'] = platformOverview!.toJson();
    }
    if (growthMetrics != null) {
      data['growth_metrics'] = growthMetrics!.toJson();
    }
    if (financialReport != null) {
      data['financial_report'] = financialReport!.toJson();
    }
    if (resourceUsage != null) {
      data['resource_usage'] = resourceUsage!.toJson();
    }
    if (operations != null) {
      data['operations'] = operations!.toJson();
    }
    if (userRoles != null) {
      data['user_roles'] = userRoles!.toJson();
    }
    data['generated_at'] = generatedAt;
    return data;
  }
}

class PlatformOverview {
  int? totalCompanies;
  int? activeCompanies;
  int? expiredCompanies;
  int? totalUsers;
  int? totalProjects;
  int? totalMachineries;

  PlatformOverview({
    this.totalCompanies,
    this.activeCompanies,
    this.expiredCompanies,
    this.totalUsers,
    this.totalProjects,
    this.totalMachineries,
  });

  PlatformOverview.fromJson(Map<String, dynamic> json) {
    totalCompanies = json['total_companies'];
    activeCompanies = json['active_companies'];
    expiredCompanies = json['expired_companies'];
    totalUsers = json['total_users'];
    totalProjects = json['total_projects'];
    totalMachineries = json['total_machineries'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_companies'] = totalCompanies;
    data['active_companies'] = activeCompanies;
    data['expired_companies'] = expiredCompanies;
    data['total_users'] = totalUsers;
    data['total_projects'] = totalProjects;
    data['total_machineries'] = totalMachineries;
    return data;
  }
}

class GrowthMetrics {
  int? newCompanies30Days;
  int? newUsers30Days;
  int? newProjects30Days;

  GrowthMetrics({
    this.newCompanies30Days,
    this.newUsers30Days,
    this.newProjects30Days,
  });

  GrowthMetrics.fromJson(Map<String, dynamic> json) {
    newCompanies30Days = json['new_companies_30_days'];
    newUsers30Days = json['new_users_30_days'];
    newProjects30Days = json['new_projects_30_days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['new_companies_30_days'] = newCompanies30Days;
    data['new_users_30_days'] = newUsers30Days;
    data['new_projects_30_days'] = newProjects30Days;
    return data;
  }
}

class FinancialReport {
  num? totalRevenue;
  num? monthlyRevenue;
  List<dynamic>? subscriptionTypes;
  int? expiringSoon;

  FinancialReport({
    this.totalRevenue,
    this.monthlyRevenue,
    this.subscriptionTypes,
    this.expiringSoon,
  });

  FinancialReport.fromJson(Map<String, dynamic> json) {
    totalRevenue = json['total_revenue'];
    monthlyRevenue = json['monthly_revenue'];
    subscriptionTypes = json['subscription_types'];
    expiringSoon = json['expiring_soon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_revenue'] = totalRevenue;
    data['monthly_revenue'] = monthlyRevenue;
    data['subscription_types'] = subscriptionTypes;
    data['expiring_soon'] = expiringSoon;
    return data;
  }
}

class ResourceUsage {
  int? totalFilesCount;
  num? totalStorageUsedMb;
  List<dynamic>? topActiveCompanies;

  ResourceUsage({
    this.totalFilesCount,
    this.totalStorageUsedMb,
    this.topActiveCompanies,
  });

  ResourceUsage.fromJson(Map<String, dynamic> json) {
    totalFilesCount = json['total_files_count'];
    totalStorageUsedMb = json['total_storage_used_mb'];
    topActiveCompanies = json['top_active_companies'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_files_count'] = totalFilesCount;
    data['total_storage_used_mb'] = totalStorageUsedMb;
    data['top_active_companies'] = topActiveCompanies;
    return data;
  }
}

class Operations {
  num? totalMachineryHours;
  num? avgHoursPerOperation;
  num? totalTransactionsSum;
  int? unresolvedAlertsCount;

  Operations({
    this.totalMachineryHours,
    this.avgHoursPerOperation,
    this.totalTransactionsSum,
    this.unresolvedAlertsCount,
  });

  Operations.fromJson(Map<String, dynamic> json) {
    totalMachineryHours = json['total_machinery_hours'];
    avgHoursPerOperation = json['avg_hours_per_operation'];
    totalTransactionsSum = json['total_transactions_sum'];
    unresolvedAlertsCount = json['unresolved_alerts_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_machinery_hours'] = totalMachineryHours;
    data['avg_hours_per_operation'] = avgHoursPerOperation;
    data['total_transactions_sum'] = totalTransactionsSum;
    data['unresolved_alerts_count'] = unresolvedAlertsCount;
    return data;
  }
}

class UserRoles {
  int? superAdmins;
  int? companyAdmins;
  int? clients;

  UserRoles({
    this.superAdmins,
    this.companyAdmins,
    this.clients,
  });

  UserRoles.fromJson(Map<String, dynamic> json) {
    superAdmins = json['super_admins'];
    companyAdmins = json['company_admins'];
    clients = json['clients'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['super_admins'] = superAdmins;
    data['company_admins'] = companyAdmins;
    data['clients'] = clients;
    return data;
  }
}
