import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../common/error_handler.dart';
import '../../common/flavor_config.dart';
import '../../common/styles.dart';
import '../../l10n/app_localizations.dart';
import '../../provider/story_provider.dart';
import '../../provider/upload_provider.dart';
import '../widgets/custom_notification.dart';

class AddStoryScreen extends StatefulWidget {
  final VoidCallback onUploadSuccess;
  final VoidCallback onBack;
  final void Function(void Function(LatLng)) onPickLocation;

  const AddStoryScreen({
    super.key,
    required this.onUploadSuccess,
    required this.onBack,
    required this.onPickLocation,
  });

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _openLocationPicker() {
    final l10n = AppLocalizations.of(context)!;
    final uploadProvider = context.read<UploadProvider>();
    widget.onPickLocation((latLng) {
      uploadProvider.setLocation(
        latLng,
        searchingPlaceholder: l10n.searchingAddress,
      );
    });
  }

  Future<void> _handleUpload() async {
    final l10n = AppLocalizations.of(context)!;
    final uploadProvider = context.read<UploadProvider>();

    if (uploadProvider.imageBytes == null) {
      AppNotification.showError(
        context,
        title: l10n.error,
        message: l10n.imageNotSelected,
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await uploadProvider.uploadStory(
      description: _descriptionController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      AppNotification.showSuccess(
        context,
        title: l10n.success,
        message: l10n.uploadSuccess,
      );
      uploadProvider.reset();
      context.read<StoryProvider>().fetchAllStories();
      widget.onUploadSuccess();
    } else {
      final errorMsg = ErrorHandler.mapErrorToMessage(
        context,
        uploadProvider.errorMessage,
      );
      AppNotification.showError(context, title: l10n.error, message: errorMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final uploadProvider = context.watch<UploadProvider>();
    final isPaid = FlavorConfig.instance.isPaid;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _descriptionController,
      builder: (context, descValue, _) {
        final charCount = descValue.text.length;
        final canPost =
            uploadProvider.imageBytes != null &&
            descValue.text.trim().isNotEmpty &&
            !uploadProvider.isUploading;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.close_rounded,
                color: AppColors.textPrimary,
              ),
              tooltip: l10n.cancel,
              onPressed: () {
                uploadProvider.reset();
                widget.onBack();
              },
            ),
            title: Text(
              l10n.startThreadTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: SizedBox(
                    height: 34,
                    child: ElevatedButton(
                      onPressed: canPost ? _handleUpload : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        disabledBackgroundColor:
                            AppColors.border.withValues(alpha: 0.8),
                        disabledForegroundColor: AppColors.textSecondary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: uploadProvider.isUploading
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              l10n.postButton,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Composer Main Scroll Area
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column: User Avatar & Guide Line
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 19,
                              backgroundColor: AppColors.primary.withValues(
                                alpha: 0.18,
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                color: AppColors.primaryDark,
                                size: 22,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 1.8,
                              height: 140,
                              decoration: BoxDecoration(
                                color: AppColors.border.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 14),

                        // Right Column: Privacy, Input, Media Preview, Location Chip
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Author name & privacy badge
                              Row(
                                children: [
                                  Text(
                                    l10n.you,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.border,
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.public_rounded,
                                          size: 11,
                                          color: AppColors.textSecondary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          l10n.publicAudience,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              // Auto-expanding borderless text input
                              TextFormField(
                                controller: _descriptionController,
                                maxLines: null,
                                minLines: 3,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return l10n.descriptionEmpty;
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                  height: 1.4,
                                ),
                                decoration: InputDecoration(
                                  hintText: l10n.threadComposerHint,
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textSecondary.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Selected Image Preview (Twitter/Threads media attachment)
                              if (uploadProvider.imageBytes != null) ...[
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColors.border.withValues(
                                              alpha: 0.7,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Image.memory(
                                          uploadProvider.imageBytes!,
                                          width: double.infinity,
                                          height: 220,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Material(
                                        color: Colors.black54,
                                        shape: const CircleBorder(),
                                        child: InkWell(
                                          customBorder: const CircleBorder(),
                                          onTap: () =>
                                              uploadProvider.clearImage(),
                                          child: const Padding(
                                            padding: EdgeInsets.all(6.0),
                                            child: Icon(
                                              Icons.close_rounded,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                              ] else ...[
                                // Placeholder quick-upload button
                                InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () =>
                                      uploadProvider.pickFromGallery(),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryLight.withValues(
                                        alpha: 0.6,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.3,
                                        ),
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 18,
                                          color: AppColors.primaryDark,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          l10n.attachStoryPhoto,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primaryDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],

                              // Selected Location Chip (Twitter style location pill)
                              if (uploadProvider.pickedLocation != null) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.4,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.location_on_rounded,
                                        color: AppColors.primaryDark,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          uploadProvider.isLoadingLocation
                                              ? l10n.searchingAddress
                                              : (uploadProvider.pickedLocationAddress ??
                                                  l10n.locationSelected),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryDark,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      InkWell(
                                        onTap: () =>
                                            uploadProvider.removeLocation(),
                                        child: const Icon(
                                          Icons.close_rounded,
                                          size: 15,
                                          color: AppColors.primaryDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],

                              // Free Tier notice for location
                              if (!isPaid) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.lock_outline_rounded,
                                        size: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        l10n.locationOnlyOnProNotice,
                                        style: const TextStyle(
                                          fontSize: 9,
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Toolbar (Twitter / Threads style media accessories & char counter)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: AppColors.border.withValues(alpha: 0.7),
                      width: 0.8,
                    ),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      // Camera button
                      IconButton(
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        tooltip: l10n.camera,
                        onPressed: uploadProvider.isUploading
                            ? null
                            : () => uploadProvider.pickFromCamera(),
                      ),
                      // Gallery button
                      IconButton(
                        icon: const Icon(
                          Icons.photo_library_outlined,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        tooltip: l10n.gallery,
                        onPressed: uploadProvider.isUploading
                            ? null
                            : () => uploadProvider.pickFromGallery(),
                      ),
                      // Location pin button
                      IconButton(
                        icon: Icon(
                          uploadProvider.pickedLocation != null
                              ? Icons.location_on_rounded
                              : Icons.location_on_outlined,
                          color: isPaid
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          size: 22,
                        ),
                        tooltip: isPaid
                            ? l10n.pickLocation
                            : l10n.locationPickerAvailableOnPaid,
                        onPressed: isPaid
                            ? _openLocationPicker
                            : () {
                                AppNotification.showError(
                                  context,
                                  title: l10n.proFeature,
                                  message:
                                      l10n.locationPickerAvailableOnPaid,
                                );
                              },
                      ),
                      const Spacer(),
                      // Twitter-style character progress indicator
                      if (charCount > 0) ...[
                        Text(
                          '$charCount',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            value: (charCount / 300).clamp(0.0, 1.0),
                            strokeWidth: 2,
                            color: charCount > 280
                                ? Colors.redAccent
                                : AppColors.primary,
                            backgroundColor: AppColors.border,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
