import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../common/styles.dart';
import '../../l10n/app_localizations.dart';
import '../../provider/location_picker_provider.dart';
import '../widgets/custom_notification.dart';

class LocationPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;
  final void Function(LatLng location) onLocationPicked;
  final VoidCallback onCancel;

  const LocationPickerScreen({
    super.key,
    this.initialLocation,
    required this.onLocationPicked,
    required this.onCancel,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LocationPickerProvider>().init(widget.initialLocation);
      }
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _zoomIn() {
    _mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    _mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  Future<void> _fetchCurrentLocation(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final provider = context.read<LocationPickerProvider>();
    final target = await provider.fetchCurrentLocation(
      onPermissionDenied: (msg) {
        if (context.mounted) {
          AppNotification.showError(context, title: l10n.error, message: msg);
        }
      },
      onGpsDisabled: (msg) {
        if (context.mounted) {
          AppNotification.showError(context, title: 'GPS', message: msg);
        }
      },
      permissionDeniedMessage: l10n.locationPermissionDenied,
      gpsDisabledMessage: l10n.gpsDisabled,
    );

    if (target != null && mounted) {
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: target, zoom: 16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locationProvider = context.watch<LocationPickerProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.pickLocation,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
          tooltip: l10n.cancel,
          onPressed: widget.onCancel,
        ),
      ),
      body: Stack(
        children: [
          // 1. Google Map View with Camera Padding so elements don't overlap
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initialLocation ??
                  LocationPickerProvider.defaultLocation,
              zoom: 15,
            ),
            padding: const EdgeInsets.only(bottom: 200),
            onMapCreated: (controller) => _mapController = controller,
            onTap: (position) =>
                locationProvider.updatePickedLocation(position),
            markers: locationProvider.markers,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
            mapToolbarEnabled: false,
          ),

          // 2. Floating Top Instruction Chip
          Positioned(
            top: 14,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.8),
                  ),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.touch_app_rounded,
                      size: 15,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.tapMapToPickLocation,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Floating Map Controls (GPS button & Zoom Controls) on the Right
          Positioned(
            right: 16,
            bottom: 235,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Fetch GPS Current Location Button
                Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 3,
                  shadowColor: Colors.black26,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: locationProvider.isFetchingGps
                        ? null
                        : () => _fetchCurrentLocation(context, l10n),
                    child: Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      child: locationProvider.isFetchingGps
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            )
                          : const Icon(
                              Icons.my_location_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Zoom in / Zoom out Controls (Horizontal Row)
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  elevation: 3,
                  shadowColor: Colors.black26,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(20),
                        ),
                        onTap: _zoomIn,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 8.0,
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            size: 20,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Container(width: 1, height: 20, color: AppColors.border),
                      InkWell(
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(20),
                        ),
                        onTap: _zoomOut,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 8.0,
                          ),
                          child: Icon(
                            Icons.remove_rounded,
                            size: 20,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 4. Bottom Detail Card & Confirm Button (Safe from Screen Insets & Never Covered)
          Positioned(
            left: 16,
            right: 16,
            bottom: 0,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Address information row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.primary,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.locationSelected,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              locationProvider.isLoadingAddress
                                  ? Text(
                                      l10n.searchingAddress,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                        color: AppColors.textSecondary,
                                      ),
                                    )
                                  : Text(
                                      locationProvider.pickedAddress ??
                                          l10n.locationAttached,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                        height: 1.3,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Coordinates chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Lat: ${locationProvider.pickedLocation.latitude.toStringAsFixed(5)}, Lon: ${locationProvider.pickedLocation.longitude.toStringAsFixed(5)}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Primary Confirm Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: locationProvider.isLoadingAddress
                            ? null
                            : () => widget.onLocationPicked(
                                  locationProvider.pickedLocation,
                                ),
                        icon: const Icon(Icons.check_circle_rounded, size: 20),
                        label: Text(
                          l10n.confirmLocation,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: AppColors.primary.withValues(
                            alpha: 0.5,
                          ),
                          disabledForegroundColor: Colors.white70,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
