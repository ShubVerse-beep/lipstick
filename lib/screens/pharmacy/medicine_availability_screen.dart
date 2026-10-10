import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_language.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';

import '../../services/pharmacy_service.dart';

// No longer using hardcoded kPharmacies

class MedicineAvailabilityScreen extends StatefulWidget {
  final String? medicineQuery;
  const MedicineAvailabilityScreen({this.medicineQuery, super.key});

  @override
  State<MedicineAvailabilityScreen> createState() =>
      _MedicineAvailabilityScreenState();
}

class _MedicineAvailabilityScreenState
    extends State<MedicineAvailabilityScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<PharmacySearchResult> _pharmacies = [];
  bool _isLoading = false;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _initLocationAndSearch();
  }

  Future<void> _initLocationAndSearch() async {
    setState(() => _isLoading = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          _currentPosition = await Geolocator.getCurrentPosition();
        }
      }
    } catch (_) {
      // default position handling below
    }

    if (widget.medicineQuery != null && widget.medicineQuery!.isNotEmpty) {
      _searchCtrl.text = widget.medicineQuery!;
      _performSearch();
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _performSearch() async {
    final query = _searchCtrl.text.trim();
    if (query.isEmpty) {
      setState(() {
        _pharmacies = [];
      });
      return;
    }

    setState(() => _isLoading = true);

    // Default to Indore if GPS fails
    final lat = _currentPosition?.latitude ?? 22.7196;
    final lon = _currentPosition?.longitude ?? 75.8577;

    final results =
        await PharmacyService.searchPharmaciesLocal(query, lat, lon);
    if (mounted) {
      setState(() {
        _pharmacies = results;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _openNavigation(double lat, double lon) async {
    final url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lon');
    final success = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!success) {
      final fallback = await launchUrl(url, mode: LaunchMode.inAppWebView);
      if (!fallback && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open map app')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryBg,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: const BoxDecoration(
              color: AppColors.primaryBg,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: Offset(0, 2)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.secondaryBg,
                        ),
                        child: const Icon(LucideIcons.arrowLeft,
                            color: AppColors.textDark, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      context.tr('medicine_availability'),
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.search,
                          color: AppColors.textMedium, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          onSubmitted: (_) => _performSearch(),
                          decoration: InputDecoration(
                            hintText: context.tr('search_medicine'),
                            hintStyle: const TextStyle(
                                color: AppColors.textMuted, fontSize: 13),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: IconButton(
                          onPressed: _performSearch,
                          padding: EdgeInsets.zero,
                          icon: const Icon(LucideIcons.arrowRight,
                              size: 16, color: AppColors.primaryAccent),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              children: [
                // Map Preview
                Container(
                  height: 160,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 6,
                          offset: Offset(0, 2)),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(
                            _currentPosition?.latitude ?? 22.7196,
                            _currentPosition?.longitude ?? 75.8577),
                        initialZoom: 13.5,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.ruralcare.app',
                        ),
                        MarkerLayer(
                          markers: _pharmacies.map((res) {
                            final p = res.pharmacy;
                            return Marker(
                              point: LatLng(p.latitude, p.longitude),
                              width: 36,
                              height: 36,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: res.isAvailable
                                      ? AppColors.success
                                      : AppColors.error,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: AppColors.shadow, blurRadius: 4),
                                  ],
                                ),
                                child: const Icon(LucideIcons.building2,
                                    color: Colors.white, size: 18),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr('nearby_pharmacies'),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark),
                    ),
                    if (_isLoading)
                      const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2)),
                  ],
                ),
                const SizedBox(height: 12),

                if (!_isLoading && _pharmacies.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        _searchCtrl.text.isEmpty
                            ? 'Search for a medicine to see availability.'
                            : 'No pharmacies configured or synced nearby.',
                        style: const TextStyle(color: AppColors.textMuted),
                      ),
                    ),
                  ),

                // Pharmacy Cards
                ..._pharmacies.map((res) {
                  final p = res.pharmacy;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        p.name,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textDark),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: res.isAvailable
                                            ? AppColors.leafGreenPale
                                            : AppColors.secondaryBg,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        res.isAvailable
                                            ? context.tr('available')
                                            : context.tr('out_of_stock'),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: res.isAvailable
                                              ? AppColors.success
                                              : AppColors.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  p.address,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textDark
                                          .withValues(alpha: 0.6)),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(LucideIcons.mapPin,
                                        size: 14, color: AppColors.textMedium),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${res.distanceKm.toStringAsFixed(1)} km ${context.tr('away')}',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textMedium),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () =>
                                _openNavigation(p.latitude, p.longitude),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.primaryAccent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(LucideIcons.navigation,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
