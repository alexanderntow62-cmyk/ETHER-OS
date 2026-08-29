class BusinessState {
  final String name;

  final List<String> goals;
  final List<String> products;
  final List<String> customers;
  final List<String> suppliers;
  final List<String> completedActions;
  final List<String> pendingActions;

  double revenue;
  double expenses;

  BusinessState({
    this.name = 'ETHER Business',
    List<String>? goals,
    List<String>? products,
    List<String>? customers,
    List<String>? suppliers,
    List<String>? completedActions,
    List<String>? pendingActions,
    this.revenue = 0,
    this.expenses = 0,
  }) : goals = goals ?? [],
       products = products ?? [],
       customers = customers ?? [],
       suppliers = suppliers ?? [],
       completedActions = completedActions ?? [],
       pendingActions = pendingActions ?? [];

  double get profit => revenue - expenses;

  bool get hasBusinessActivity =>
      products.isNotEmpty ||
      customers.isNotEmpty ||
      suppliers.isNotEmpty ||
      revenue > 0 ||
      expenses > 0;

  void addGoal(String goal) {
    final value = goal.trim();

    if (value.isEmpty || goals.contains(value)) {
      return;
    }

    goals.add(value);
  }

  void addProduct(String product) {
    final value = product.trim();

    if (value.isEmpty || products.contains(value)) {
      return;
    }

    products.add(value);
  }

  void addCustomer(String customer) {
    final value = customer.trim();

    if (value.isEmpty || customers.contains(value)) {
      return;
    }

    customers.add(value);
  }

  void addSupplier(String supplier) {
    final value = supplier.trim();

    if (value.isEmpty || suppliers.contains(value)) {
      return;
    }

    suppliers.add(value);
  }

  void addPendingAction(String action) {
    final value = action.trim();

    if (value.isEmpty || pendingActions.contains(value)) {
      return;
    }

    pendingActions.add(value);
  }

  void completeAction(String action) {
    final value = action.trim();

    if (value.isEmpty) {
      return;
    }

    pendingActions.remove(value);

    if (!completedActions.contains(value)) {
      completedActions.add(value);
    }
  }

  void recordRevenue(double amount) {
    if (amount > 0) {
      revenue += amount;
    }
  }

  void recordExpense(double amount) {
    if (amount > 0) {
      expenses += amount;
    }
  }

  String summary() {
    return [
      'BUSINESS STATE',
      'Name: $name',
      'Goals: ${goals.length}',
      'Products: ${products.length}',
      'Customers: ${customers.length}',
      'Suppliers: ${suppliers.length}',
      'Revenue: $revenue',
      'Expenses: $expenses',
      'Profit: $profit',
      'Pending actions: ${pendingActions.length}',
      'Completed actions: ${completedActions.length}',
    ].join('\n');
  }
}
