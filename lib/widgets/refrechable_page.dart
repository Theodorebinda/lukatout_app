import 'package:flutter/material.dart';

class RefreshablePage extends StatefulWidget {
  final Future<void> Function()
      onRefresh; // Fonction qui sera appelée lors du refresh
  final Widget child; // Contenu de la page
  final Color? indicatorColor; // Couleur du RefreshIndicator
  final Color? backgroundColor; // Couleur de fond du RefreshIndicator

  const RefreshablePage({
    super.key,
    required this.onRefresh,
    required this.child,
    this.indicatorColor,
    this.backgroundColor,
  });

  @override
  // ignore: library_private_types_in_public_api
  _RefreshablePageState createState() => _RefreshablePageState();
}

class _RefreshablePageState extends State<RefreshablePage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      color: widget.indicatorColor ?? Theme.of(context).primaryColor,
      backgroundColor: widget.backgroundColor ?? Colors.white,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: widget.child,
      ),
    );
  }
}
