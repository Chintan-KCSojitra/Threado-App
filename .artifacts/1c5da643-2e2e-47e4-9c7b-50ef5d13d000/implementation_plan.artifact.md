# Implementation Plan - Replace `social_sharing_plus` with `whatsapp_share_plus`

Replace the generic `social_sharing_plus` library with the specialized `whatsapp_share_plus` library for more reliable direct-to-WhatsApp sharing.

## User Review Required

> [!IMPORTANT]
> The `whatsapp_share_plus` library specifically handles WhatsApp (and WhatsApp Business). This change will streamline the WhatsApp inquiry flow by using a more targeted plugin that handles phone numbers and file caching better for this specific use case.

## Proposed Changes

### [Component] Project Configuration

#### [MODIFY] [pubspec.yaml](file:///C:/Users/chint/Downloads/Thredo/Thredo/Thredo/pubspec.yaml)
- Remove `social_sharing_plus: ^1.2.3`.
- Add `whatsapp_share_plus: ^1.0.2`.

### [Component] Utilities

#### [MODIFY] [whatsapp_utils.dart](file:///C:/Users/chint/Downloads/Thredo/Thredo/Thredo/lib/utils/whatsapp_utils.dart)
- Replace `SocialSharingPlus` with `WhatsappSharePlus`.
- Update `shareToWhatsAppWithImage` to use `WhatsappSharePlus.shareToWhatsapp`.
- Note: `whatsapp_share_plus` supports passing a `phone` number directly even when sharing an image, which should improve the "Contact Supplier" flow.

## Verification Plan

### Manual Verification
- **Test WhatsApp Share with Image**:
  - Open a product detail screen.
  - Tap the WhatsApp icon.
  - Verify that WhatsApp opens with the product image and message.
- **Test Fallback**:
  - Verify that if the share fails, it still has a logical fallback.
- **Verify Dependency**:
  - Run `flutter pub get` to ensure the new dependency is correctly installed.
