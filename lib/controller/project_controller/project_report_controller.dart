import 'package:contracting_management_dashbord/model/bond/bond_model.dart';
import 'package:contracting_management_dashbord/model/bond/filter_bond.dart';
import 'package:contracting_management_dashbord/model/box/box_model.dart';
import 'package:contracting_management_dashbord/model/project/project_model.dart';
import 'package:contracting_management_dashbord/model/unit/unit_model.dart';
import 'package:contracting_management_dashbord/repo/bond_repo.dart';
import 'package:contracting_management_dashbord/repo/box_repo.dart';
import 'package:contracting_management_dashbord/repo/project_repo.dart';
import 'package:contracting_management_dashbord/repo/unit_repo.dart';
import 'package:get/get.dart';

class ProjectReportController extends GetxController {
  final ProjectRepo _projectRepo = ProjectRepo();
  final BondRepo _bondRepo = BondRepo();
  final UnitRepo _unitRepo = UnitRepo();
  final BoxRepo _boxRepo = BoxRepo();

  var isLoading = false.obs;
  var projects = <ProjectModel>[].obs;
  var selectedProject = Rxn<ProjectModel>();

  // Box Data
  var selectedBox = Rxn<BoxModel>();
  var boxBonds = <BondModel>[].obs;

  // Financial Data
  var withdrawals = <BondModel>[].obs;
  var deposits = <BondModel>[].obs;

  // Units Data
  var units = <UnitModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    try {
      isLoading.value = true;
      final response = await _projectRepo.getAllProjects();
      if (response.status == true) {
        List<dynamic> list = [];
        if (response.data is List) {
          list = response.data;
        } else if (response.data is Map && response.data['data'] is List) {
          list = response.data['data'];
        }
        projects.value = list.map((e) => ProjectModel.fromJson(e)).toList();
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectProject(ProjectModel project) async {
    selectedProject.value = project;
    await fetchProjectData();
  }

  Future<void> fetchProjectData() async {
    if (selectedProject.value == null) return;

    try {
      isLoading.value = true;
      // Clear previous data
      selectedBox.value = null;
      boxBonds.clear();
      withdrawals.clear();
      deposits.clear();
      units.clear();

      await Future.wait([fetchBoxDetails(), fetchUnits()]);

      // Fetch financial data (depends on box or project ID)
      await Future.wait([fetchWithdrawals(), fetchDeposits()]);
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchBoxDetails() async {
    try {
      final project = selectedProject.value;
      if (project == null || project.boxId == null) {
        selectedBox.value = null;
        boxBonds.value = [];
        return;
      }

      // Get the first box ID from project
      final boxId = project.boxId;
      if (boxId == null) return;

      // Fetch detailed box information
      final response = await _boxRepo.getBoxById(boxId);

      if (response.status == true) {
        if (response.data is List && response.data.isNotEmpty) {
          selectedBox.value = BoxModel.fromJson(response.data[0]);
        } else if (response.data is Map<String, dynamic>) {
          selectedBox.value = BoxModel.fromJson(response.data);
        } else if (response.data is BoxModel) {
          selectedBox.value = response.data;
        }
      }

      // Fetch box bonds
      final filter = FilterBond(boxId: boxId);
      final bondsResponse = await _bondRepo.filterBonds(filter);

      if (bondsResponse.status == true) {
        List<dynamic> bondsList = [];
        if (bondsResponse.data is List) {
          bondsList = bondsResponse.data;
        } else if (bondsResponse.data is Map &&
            bondsResponse.data['data'] is List) {
          bondsList = bondsResponse.data['data'];
        }

        boxBonds.value = bondsList.map((e) {
          if (e is BondModel) {
            return e;
          } else {
            return BondModel.fromJson(e as Map<String, dynamic>);
          }
        }).toList();
      }
    } catch (e) {
      selectedBox.value = null;
      boxBonds.value = [];
    }
  }

  Future<void> fetchWithdrawals() async {
    int? boxId;
    if (selectedBox.value != null) {
      boxId = selectedBox.value!.id;
    } else if (selectedProject.value != null &&
        selectedProject.value!.boxId != null) {
      boxId = selectedProject.value!.boxId;
    }

    if (boxId == null) return;

    try {
      final filter = FilterBond(
        bondTypeId: 1, // Withdrawal
        boxId: boxId,
      );

      final response = await _bondRepo.filterBonds(filter);

      if (response.status == true) {
        List<dynamic> list = [];
        if (response.data is List) {
          list = response.data;
        } else if (response.data is Map && response.data['data'] is List) {
          list = response.data['data'];
        }

        withdrawals.value = list.map((e) {
          if (e is BondModel) {
            return e;
          } else {
            return BondModel.fromJson(e as Map<String, dynamic>);
          }
        }).toList();
      }
    } catch (e) {
      withdrawals.value = [];
    }
  }

  Future<void> fetchDeposits() async {
    int? boxId;
    if (selectedBox.value != null) {
      boxId = selectedBox.value!.id;
    } else if (selectedProject.value != null &&
        selectedProject.value!.boxId != null) {
      boxId = selectedProject.value!.boxId;
    }

    if (boxId == null) return;

    try {
      final filter = FilterBond(
        bondTypeId: 2, // Deposit
        boxId: boxId,
      );

      final response = await _bondRepo.filterBonds(filter);

      if (response.status == true) {
        List<dynamic> list = [];
        if (response.data is List) {
          list = response.data;
        } else if (response.data is Map && response.data['data'] is List) {
          list = response.data['data'];
        }

        deposits.value = list.map((e) {
          if (e is BondModel) {
            return e;
          } else {
            return BondModel.fromJson(e as Map<String, dynamic>);
          }
        }).toList();
      }
    } catch (e) {
      deposits.value = [];
    }
  }

  Future<void> fetchUnits() async {
    if (selectedProject.value == null) return;

    try {
      final response = await _unitRepo.getUnitsByProject(
        selectedProject.value!.id.toString(),
      );

      if (response.status == true) {
        List<dynamic> list = [];
        if (response.data is List) {
          list = response.data;
        } else if (response.data is Map && response.data['data'] is List) {
          list = response.data['data'];
        }

        units.value = list.map((e) {
          if (e is UnitModel) {
            return e;
          } else {
            return UnitModel.fromJson(e as Map<String, dynamic>);
          }
        }).toList();
      }
    } catch (e) {
      units.value = [];
    }
  }

  double get totalWithdrawals {
    return withdrawals.fold(0.0, (sum, bond) {
      final amount =
          double.tryParse(bond.amount?.toString().replaceAll(',', '') ?? '0') ??
          0;
      return sum + amount;
    });
  }

  // Calculate total deposits
  double get totalDeposits {
    return deposits.fold(0.0, (sum, bond) {
      final amount =
          double.tryParse(bond.amount?.toString().replaceAll(',', '') ?? '0') ??
          0;
      return sum + amount;
    });
  }

  // Get sold units count
  int get soldUnitsCount {
    return units
        .where((unit) => unit.customers != null && unit.customers!.isNotEmpty)
        .length;
  }

  // Get available units count
  int get availableUnitsCount {
    return units
        .where((unit) => unit.customers == null || unit.customers!.isEmpty)
        .length;
  }

  // Calculate sales percentage
  double get salesPercentage {
    if (units.isEmpty) return 0;
    return (soldUnitsCount / units.length) * 100;
  }

  // Calculate percentage for deposits (relative to target or max)
  int get depositsPercentage {
    final project = selectedProject.value;
    if (project == null) return 0;
    final debit = project.debit ?? 0;
    final target = (project.unitsCount ?? 1) * 1000000; // Example target
    if (target == 0) return 0;
    return ((debit / target) * 100).clamp(0, 100).toInt();
  }

  // Calculate percentage for withdrawals
  int get withdrawalsPercentage {
    final project = selectedProject.value;
    if (project == null) return 0;
    final credit = project.credit ?? 0;
    final target = (project.unitsCount ?? 1) * 500000; // Example target
    if (target == 0) return 0;
    return ((credit / target) * 100).clamp(0, 100).toInt();
  }

  // Calculate percentage for balance
  int get balancePercentage {
    final project = selectedProject.value;
    if (project == null) return 0;
    final balance = project.balance ?? 0;
    final debit = project.debit ?? 1;
    if (debit == 0) return 0;
    return ((balance / debit) * 100).clamp(0, 100).toInt();
  }

  // Get weekly data for chart (last 7 days)
  List<Map<String, double>> getWeeklyData() {
    final now = DateTime.now();
    final weeklyData = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));

      // Filter deposits for this day
      final dayDeposits = deposits.where((bond) {
        if (bond.createdAt == null) return false;
        try {
          final bondDate = DateTime.parse(bond.createdAt!);
          return bondDate.year == date.year &&
              bondDate.month == date.month &&
              bondDate.day == date.day;
        } catch (e) {
          return false;
        }
      });

      // Filter withdrawals for this day
      final dayWithdrawals = withdrawals.where((bond) {
        if (bond.createdAt == null) return false;
        try {
          final bondDate = DateTime.parse(bond.createdAt!);
          return bondDate.year == date.year &&
              bondDate.month == date.month &&
              bondDate.day == date.day;
        } catch (e) {
          return false;
        }
      });

      // Calculate totals
      final depositsTotal = dayDeposits.fold(0.0, (sum, bond) {
        final amount =
            double.tryParse(
              bond.amount?.toString().replaceAll(',', '') ?? '0',
            ) ??
            0;
        return sum + amount;
      });

      final withdrawalsTotal = dayWithdrawals.fold(0.0, (sum, bond) {
        final amount =
            double.tryParse(
              bond.amount?.toString().replaceAll(',', '') ?? '0',
            ) ??
            0;
        return sum + amount;
      });

      return {
        'deposits':
            depositsTotal /
            1000, // Convert to thousands for better chart display
        'withdrawals': withdrawalsTotal / 1000,
      };
    });

    return weeklyData;
  }

  // Calculate deposit trend percentage
  String get depositTrend {
    if (deposits.length < 2) return "+0%";

    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));
    final twoWeeksAgo = now.subtract(const Duration(days: 14));

    final lastWeekDeposits = deposits
        .where((bond) {
          if (bond.createdAt == null) return false;
          try {
            final date = DateTime.parse(bond.createdAt!);
            return date.isAfter(lastWeek);
          } catch (e) {
            return false;
          }
        })
        .fold(0.0, (sum, bond) {
          final amount =
              double.tryParse(
                bond.amount?.toString().replaceAll(',', '') ?? '0',
              ) ??
              0;
          return sum + amount;
        });

    final previousWeekDeposits = deposits
        .where((bond) {
          if (bond.createdAt == null) return false;
          try {
            final date = DateTime.parse(bond.createdAt!);
            return date.isAfter(twoWeeksAgo) && date.isBefore(lastWeek);
          } catch (e) {
            return false;
          }
        })
        .fold(0.0, (sum, bond) {
          final amount =
              double.tryParse(
                bond.amount?.toString().replaceAll(',', '') ?? '0',
              ) ??
              0;
          return sum + amount;
        });

    if (previousWeekDeposits == 0) return "+100%";
    final change =
        ((lastWeekDeposits - previousWeekDeposits) /
        previousWeekDeposits *
        100);
    return "${change >= 0 ? '+' : ''}${change.toStringAsFixed(0)}%";
  }

  // Calculate withdrawal trend percentage
  String get withdrawalTrend {
    if (withdrawals.length < 2) return "+0%";

    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));
    final twoWeeksAgo = now.subtract(const Duration(days: 14));

    final lastWeekWithdrawals = withdrawals
        .where((bond) {
          if (bond.createdAt == null) return false;
          try {
            final date = DateTime.parse(bond.createdAt!);
            return date.isAfter(lastWeek);
          } catch (e) {
            return false;
          }
        })
        .fold(0.0, (sum, bond) {
          final amount =
              double.tryParse(
                bond.amount?.toString().replaceAll(',', '') ?? '0',
              ) ??
              0;
          return sum + amount;
        });

    final previousWeekWithdrawals = withdrawals
        .where((bond) {
          if (bond.createdAt == null) return false;
          try {
            final date = DateTime.parse(bond.createdAt!);
            return date.isAfter(twoWeeksAgo) && date.isBefore(lastWeek);
          } catch (e) {
            return false;
          }
        })
        .fold(0.0, (sum, bond) {
          final amount =
              double.tryParse(
                bond.amount?.toString().replaceAll(',', '') ?? '0',
              ) ??
              0;
          return sum + amount;
        });

    if (previousWeekWithdrawals == 0) return "+100%";
    final change =
        ((lastWeekWithdrawals - previousWeekWithdrawals) /
        previousWeekWithdrawals *
        100);
    return "${change >= 0 ? '+' : ''}${change.toStringAsFixed(0)}%";
  }

  // Get box deposits (from box model)
  double get boxDeposits {
    final box = selectedBox.value;
    if (box == null) return 0;
    return double.tryParse(box.debit?.toString().replaceAll(',', '') ?? '0') ??
        0;
  }

  // Get box withdrawals (from box model)
  double get boxWithdrawals {
    final box = selectedBox.value;
    if (box == null) return 0;
    return double.tryParse(box.credit?.toString().replaceAll(',', '') ?? '0') ??
        0;
  }

  // Get box bill debit (from box model)
  double get boxBillDebit {
    final box = selectedBox.value;
    if (box == null) return 0;
    return double.tryParse(
          box.billDebit?.toString().replaceAll(',', '') ?? '0',
        ) ??
        0;
  }

  // Get box customer debit (from box model)
  double get boxCustomerDebit {
    final box = selectedBox.value;
    if (box == null) return 0;
    return double.tryParse(
          box.customerDebit?.toString().replaceAll(',', '') ?? '0',
        ) ??
        0;
  }

  // Get project deposits (from project model)
  double get projectDeposits {
    final project = selectedProject.value;
    if (project == null) return 0;
    return project.debit?.toDouble() ?? 0;
  }

  // Get project withdrawals (from project model)
  double get projectWithdrawals {
    final project = selectedProject.value;
    if (project == null) return 0;
    return project.credit?.toDouble() ?? 0;
  }

  // Get project bill debit (from project model)
  double get projectBillDebit {
    final project = selectedProject.value;
    if (project == null) return 0;
    return project.billDebit?.toDouble() ?? 0;
  }

  // Get project balance (from project model)
  double get projectBalance {
    final project = selectedProject.value;
    if (project == null) return 0;
    return project.balance?.toDouble() ?? 0;
  }

  // ========== Sales Analysis ==========

  // Total expected sales (sum of all units cost)
  double get totalExpectedSales {
    return units.fold(0.0, (sum, unit) {
      final cost =
          double.tryParse(unit.cost?.toString().replaceAll(',', '') ?? '0') ??
          0;
      return sum + cost;
    });
  }

  // Total actual collected money (bill_debit + customer_debit from box)
  double get totalActualCollected {
    return boxBillDebit + boxCustomerDebit;
  }

  // Collection percentage
  double get collectionPercentage {
    if (totalExpectedSales == 0) return 0;
    return (totalActualCollected / totalExpectedSales) * 100;
  }

  // Remaining amount to collect
  double get remainingToCollect {
    return totalExpectedSales - totalActualCollected;
  }
}
