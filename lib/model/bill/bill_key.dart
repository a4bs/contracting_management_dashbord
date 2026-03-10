class BillGetKey {
  static const String note = 'note';
  static const String installmentDateFrom = 'installment_date_from';
  static const String installmentDateTo = 'installment_date_to';
  static const String isScheduledInstallment = 'is_scheduled_installment';
  static const String plot = 'plot';
  static const String boxId = 'box_id';
  static const String unitId = 'unit_id';
  static const String customer = 'customer';
  static const String id = 'id';
  static const String createdAtFrom = 'created_at_from';
  static const String createdAtTo = 'created_at_to';
}

class BillAddKey {
  static const String name = 'name';
  static const String projectId = 'project_id';
  static const String projectTypeId = 'project_type_id';
  static const String projectStatusId = 'project_status_id';
  static const String cost = 'cost';
  static const String unitName = 'unit_name';
  static const String unitCount = 'unit_count';
  static const String unitCost = 'unit_cost';
  static const String note = 'note';
  static const String installmentDateAt = 'installment_date_at';
  static const String isScheduledInstallment = 'is_scheduled_installment';
  static const String salePrice = 'sale_price';
  static const String downPayment = 'down_payment';
  static const String plot = 'plot';
  static const String boxId = 'box_id';
  static const String unitId = 'unit_id';
  static const String customerId = 'customer_id';
  static const String bondIds = 'bond_ids';
}

class BillUpdateKey {
  static const String installmentDateAt = 'installment_date_at';
  static const String isScheduledInstallment = 'is_scheduled_installment';
  static const String salePrice = 'sale_price';
  static const String downPayment = 'down_payment';
  static const String plot = 'plot';
  static const String boxId = 'box_id';
  static const String unitId = 'unit_id';
  static const String customerId = 'customer_id';
  static const String bondIds = 'bond_ids[]';
}

class BillDeleteKey {
  static const String id = 'id';
}

class BillFilterKey {
  static const String note = 'note';
  static const String installmentDateFrom = 'installment_date_from';
  static const String installmentDateTo = 'installment_date_to';
  static const String isScheduledInstallment = 'is_scheduled_installment';
  static const String plot = 'plot';
  static const String boxId = 'box_id';
  static const String projectId = 'project_id';
  static const String unitId = 'unit_id';
  static const String customer = 'customer';
  static const String id = 'id';
  static const String createdAtFrom = 'created_at_from';
  static const String createdAtTo = 'created_at_to';
  static const String page = 'page';
  static const String limit = 'limit';
}
