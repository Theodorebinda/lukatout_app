class IAppMenu {
  final String id;
  final dynamic icon;
  final String name;
  final String path;
  final String app;
  final String verbose;
  final List<IAppMenu> subMenus;

  // final List<dynamic> permissions;
  IAppMenu({
    required this.id,
    required this.icon,
    required this.name,
    required this.path,
    required this.app,
    required this.verbose,
    required this.subMenus,
  });

  factory IAppMenu.fromJson(Map<String, dynamic> json) {
    List<IAppMenu> listSubMenu = [];
    if (json.containsKey('subMenus') && json['subMenus'] != null) {
      for (var i = 0; i < json['subMenus'].length; i++) {
        final elem = json['subMenus'][i];
        listSubMenu.add(IAppMenu.fromJson(elem));
      }
    }
    return IAppMenu(
      icon:
          json.containsKey('icon') && json['icon'] != null ? json['icon'] : '-',
      app: json.containsKey('app') && json['app'] != null ? json['app'] : '-',
      verbose: json.containsKey('verbose') && json['app'] != null
          ? json['verbose']
          : '-',
      id: json.containsKey('id') && json['id'] != null ? json['id'] : '-',
      name:
          json.containsKey('name') && json['name'] != null ? json['name'] : '-',
      path:
          json.containsKey('path') && json['path'] != null ? json['path'] : '-',
      // permissions: json.containsKey('permissions') ? json['permissions'] : [],
      subMenus: json.containsKey('subMenus') ? listSubMenu : [],
    );
  }
  @override
  String toString() {
    return '''
        IAppMenu(
          verbose : $verbose,
          id    : $id,
          name  : $name,
          subMenus : $subMenus,
          app : $app,
        )
    ''';
  }
}
