enum AppRole {
  customer,
  collector,
  admin,
}

String appRoleTitle(AppRole role) {
  switch (role) {
    case AppRole.customer:
      return 'ভাঙারি Customer';
    case AppRole.collector:
      return 'Collector Mode';
    case AppRole.admin:
      return 'Admin Dashboard';
  }
}
