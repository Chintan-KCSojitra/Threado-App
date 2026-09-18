# Thredo (Threado) — Company Role Extension
## Product Requirements Document (PRD)

| Field | Value |
|-------|-------|
| **Document version** | 1.0 |
| **Date** | 21 May 2026 |
| **Application** | Thredo (Threado) — Flutter mobile app |
| **Package** | `com.app.thredo` |
| **Scope** | Add **Company** role alongside existing **User** (trader) role |

---

## 1. Executive Summary

Thredo is currently a **user-facing B2B thread marketplace** where traders browse products, match threads by image, discover companies, and manage wishlists. The app has a single navigation shell and all APIs use the `user/` namespace. The login response already includes a `role` field, but it is **not used** for routing or UI branching.

This document defines requirements to introduce a **Company role** so that registered companies can:

- View and manage **only their own products** on a familiar Home-like experience
- Use **Product Reel** and **Product Detail** with appropriate restrictions
- Keep **Category** browsing unchanged
- **Exclude** the Thread Match (image scan) feature
- Access a new **Company List** screen with an **approval workflow** for cross-company product visibility
- Use a **dedicated Profile** layout showing full company details

The existing User module remains intact. Company users receive a parallel experience with role-based navigation, API scoping, and UI variants.

---

## 2. Current State — User Module Analysis

### 2.1 Application Entry & Authentication

| Step | Screen | Behavior |
|------|--------|----------|
| 1 | Splash | Logo animation; fetches header images (`POST user/images/list`) |
| 2 | Choose Language | First-run language selection (optional) |
| 3 | Login | Phone number (+91); terms acceptance |
| 4 | OTP Verification | 6-digit OTP; `POST user/auth/otp/verify` |
| 5 | Bottom Menu | Single shell for all logged-in users |

**Session storage:**

| Key | Storage | Content |
|-----|---------|---------|
| `kPrefIsLogin` | SharedPreferences | Login flag |
| `kPrefDeviceToken` | SharedPreferences | Bearer access token |
| `kPrefUserData` | Secure storage | `LoginData` JSON |

**`LoginData` model (existing):**

| Field | API key | Notes |
|-------|---------|-------|
| `accessToken` | `access_token` | JWT / bearer token |
| `tokenType` | `token_type` | Usually `Bearer` |
| `userId` | `user_id` | User UUID |
| `role` | `role` | **Stored but never read in UI** |
| `phone` | `phone` | Mobile number |

**Gap:** No post-login branch on `role`. All users land on the same `BottomMenuScreen`.

---

### 2.2 Bottom Navigation (Current — User Role)

| Tab | Screen | Primary purpose |
|-----|--------|-----------------|
| Home | `HomeScreen` | Product grid, banners, search, filters |
| Category | `CategoryScreen` | Category grid → sub-category products |
| Match | `ThreadMatchScreen` | Camera/gallery thread image match |
| Company | `CompanyScreen` | Browse supplier companies |
| Profile | `ProfileScreen` | Wishlist, language, legal, logout |

**Implementation notes:**
- Lazy-loaded tabs via `IndexedStack` (only Home pre-built at startup)
- Back on non-home tab returns to Home; back on Home shows exit dialog

---

### 2.3 Home Screen (User)

**Files:** `home_screen.dart`, `home_cubit.dart`

| Feature | Detail |
|---------|--------|
| Product grid | 3-column, infinite scroll, pull-to-refresh |
| Banners | Carousel from `GET user/banners` |
| Search | 400ms debounce → `q` query param |
| Filters | Company, color, material (single-select) |
| Navigation | Tap product → `ProductReelScreen` with full loaded list |
| Shortcuts | Wishlist, Notifications (mock) |

**API:** `GET user/products` with `page`, `per_page`, optional `q`, `company_id`, `color_id`, `material_id`

---

### 2.4 Category Screen (User)

**Files:** `category_screen.dart`, `sub_category_screen.dart`

| Feature | Detail |
|---------|--------|
| Category list | Paginated `GET user/categories` |
| Sub-category | Products filtered by `category_id` + same filters as Home |
| Navigation | Product tap → `ProductReelScreen` |

**Requirement for Company role:** **Remain unchanged** (same UI and APIs).

---

### 2.5 Thread Match Screen (User only)

**Files:** `thread_match_screen.dart`, `thread_match_cubit.dart`

| Feature | Detail |
|---------|--------|
| Upload | Camera or gallery |
| API | `POST user/images/match-thread` (multipart) |
| Results | Product grid → reel navigation |

**Requirement for Company role:** **Excluded entirely** — tab hidden, route blocked.

---

### 2.6 Company Screens (Current — User-facing browse)

These screens let **users** discover suppliers; they are **not** a company operator dashboard.

| Screen | Purpose |
|--------|---------|
| `CompanyScreen` | Searchable paginated company list |
| `CompanyProfileScreen` | Company info, reviews, shade cards, products |
| `CompanyReviewsScreen` | Paginated reviews |
| `ShadeCardPickerScreen` | Shade card selection → AR Match |

**APIs:** `GET user/companies`, `GET user/companies/{id}`, reviews CRUD, `GET user/products?company_id=`

---

### 2.7 Product Reel & Product Detail (User)

**Files:** `product_reel_screen.dart`, `product_detail_screen.dart`

| Feature | User capability |
|---------|-----------------|
| Vertical reel | Swipe through product list |
| Media carousel | Images + videos, pinch-zoom |
| Wishlist | Toggle via `POST user/wishlist/` |
| WhatsApp share | Share with image + event logging |
| Company chip | Navigate to company profile |
| Product info sheet | Full specifications |
| Embroidery Match | AI design suggestions (Gemini) |
| AR Match | Live camera thread comparison |
| Screenshot event | `POST user/events` (`product_screen_shot`) |
| Social links | Maps, Facebook, Instagram, etc. |

**APIs:** `user/products`, `user/wishlist/`, `user/events`, `user/companies/{id}`

---

### 2.8 Profile Screen (User)

**Files:** `profile_screen.dart`, `profile_cubit.dart`

| Item | Action |
|------|--------|
| Avatar | Placeholder image |
| Phone | From `LoginData` |
| Wishlist | `WishListScreen` |
| Change language | `ChangeLanguageScreen` |
| Privacy / Terms | `LegalDocumentScreen` |
| Delete account | Dialog (currently calls logout endpoint — bug) |
| Logout | `POST user/auth/logout` |

**Gap:** No name, email, role badge, or company association displayed.

---

### 2.9 Existing API Surface (User namespace)

All endpoints today use `user/` prefix (`app_config.dart`):

| Endpoint | Method | Used for |
|----------|--------|----------|
| `user/auth/otp/request` | POST | Login |
| `user/auth/otp/verify` | POST | OTP verify |
| `user/auth/logout` | POST | Logout |
| `user/profile/me` | DELETE | Delete account (defined, not wired) |
| `user/products` | GET | Products list |
| `user/banners` | GET | Home banners |
| `user/categories` | GET | Categories |
| `user/companies` | GET | Company list |
| `user/companies/{id}` | GET | Company detail |
| `user/companies/{id}/reviews` | GET/POST | Reviews |
| `user/colors/` | GET | Filter colors |
| `user/materials/` | GET | Filter materials |
| `user/wishlist/` | GET/POST | Wishlist |
| `user/wishlist/{id}` | DELETE | Remove wishlist |
| `user/events` | POST | Analytics events |
| `user/images/list` | POST | Splash header images |
| `user/images/match-thread` | POST | Thread match |
| `user/media/resize` | GET | Image resize proxy |

**No `company/` admin API namespace exists in the client today.**

---

## 3. Company Role — Business Requirements

### 3.1 Role Definition

| Role | Description |
|------|-------------|
| **User** (existing) | Trader / buyer — browses all products, matches threads, reviews companies |
| **Company** (new) | Registered supplier — manages own catalog view, requests access to peer companies |

### 3.2 Post-Login Routing

```
OTP Verify Success
        │
        ▼
   Read LoginData.role
        │
   ┌────┴────┐
   │         │
 user    company
   │         │
   ▼         ▼
UserBottom   CompanyBottom
MenuScreen   MenuScreen
```

| `role` value (proposed) | Navigation shell |
|-------------------------|------------------|
| `user` / `trader` | Existing `BottomMenuScreen` (5 tabs) |
| `company` | New `CompanyBottomMenuScreen` (4 tabs) |

---

## 4. Company Role — Screen-by-Screen Requirements

### 4.1 Home Screen (Company variant)

| Aspect | User (current) | Company (required) |
|--------|----------------|---------------------|
| **UI layout** | Same grid, search, filters, banners | **Same layout** |
| **Product scope** | All products (with filters) | **Only logged-in company's products** |
| **Banners** | Global banners | Company-specific or hidden (TBD with backend) |
| **Filter: Company** | Select any company | **Hidden or disabled** (implicit own company) |
| **Filter: Color / Material** | Available | Available (scoped to own products) |
| **Wishlist shortcut** | Visible | **Hidden** (company users don't wishlist) |
| **Notifications** | Visible | Optional / company-specific |
| **Product tap** | → Product Reel | → Product Reel (own products only) |

**API (proposed):** `GET company/products` or `GET user/products` with server-side `company_id` from token — **no client-side company_id override**.

**Reuse:** `HomeScreen` with `role` parameter or `CompanyHomeCubit` extending shared product grid logic.

---

### 4.2 Product Reel & Product Detail (Company variant)

| Feature | User | Company |
|---------|------|---------|
| Vertical reel | ✅ | ✅ (own products list only) |
| Image / video carousel | ✅ | ✅ |
| Pinch zoom | ✅ | ✅ |
| Wishlist button | ✅ | ❌ **Hidden** |
| WhatsApp share | ✅ | ⚠️ **Optional** — share own product (configurable) |
| Company chip (navigate to profile) | ✅ Other companies | ✅ **Own company profile** (read-only or edit link) |
| Product info sheet | ✅ | ✅ |
| Embroidery Match | ✅ | ❌ **Hidden** (user discovery feature) |
| AR Match | ✅ | ⚠️ **Optional** — for own product QA |
| Screenshot analytics | ✅ | ✅ (event_type may differ) |
| Review company | N/A on detail | ❌ |
| Edit product | ❌ | ⚠️ **Future phase** — out of scope v1 unless specified |
| Delete product | ❌ | ⚠️ **Future phase** |

**Restrictions rationale:** Company role is catalog management and B2B visibility, not consumer discovery tools (match, embroidery AI, wishlist).

---

### 4.3 Category Screen (Company)

| Requirement | Detail |
|-------------|--------|
| UI | **Unchanged** — same `CategoryScreen` and `SubCategoryScreen` |
| Products in sub-category | Scoped to **own company** when opened from company shell |
| Navigation | Sub-category product tap → Company Product Reel |

**Implementation:** Pass `ProductScope.ownCompany` into category flow when `role == company`.

---

### 4.4 Thread Match Screen

| Requirement | Detail |
|-------------|--------|
| Tab visibility | **Not shown** in company bottom navigation |
| Deep link / route | Blocked — redirect to Home if attempted |
| API | Company token should not call `user/images/match-thread` |

---

### 4.5 Company List Screen (New — with Approval Workflow)

**Purpose:** Allow Company A to discover other companies and **request permission** to view Company B's products.

#### 4.5.1 List View

| Element | Behavior |
|---------|----------|
| Company cards | Name, logo, location, rating (same card style as user `CompanyScreen`) |
| Search | Debounced search by company name |
| Access badge | Shows status per company: `None`, `Pending`, `Approved`, `Rejected` |
| Tap behavior | Depends on access status (see below) |

#### 4.5.2 Access States

| Status | Company A can view B's products? |
|--------|----------------------------------|
| **None** | No — show "Request Access" |
| **Pending** | No — show "Request Pending" |
| **Approved** | Yes — navigate to Company B profile / products |
| **Rejected** | No — show "Request Rejected" + option to re-request (policy TBD) |

#### 4.5.3 Request Flow (Company A → Company B)

```
Company A opens Company List
        │
        ▼
Taps Company B (no access)
        │
        ▼
"Request Access" button
        │
        ▼
POST company/access-requests { target_company_id, message? }
        │
        ▼
Status → Pending (push notification to B — optional)
```

#### 4.5.4 Approval Flow (Company B receives requests)

Accessible from **Company Profile (own)** or dedicated **"Access Requests"** section:

```
Company B → Incoming Requests list
        │
        ├── Accept → status Approved, A can view B products
        └── Reject → status Rejected, optional reason
```

#### 4.5.5 Viewing Approved Company Products

When Company A has **Approved** access to Company B:

- Navigate to `CompanyProfileScreen` (variant) or `PeerCompanyProductsScreen`
- Product grid shows **Company B's products** (read-only)
- Product detail opens with **Company restrictions** (no wishlist, no embroidery match, etc.)
- Company A **cannot** edit B's products

#### 4.5.6 Proposed APIs

| Endpoint | Method | Description |
|----------|--------|-------------|
| `company/peers` | GET | List companies with access status for current company |
| `company/access-requests` | POST | Send access request |
| `company/access-requests/incoming` | GET | Requests received by current company |
| `company/access-requests/outgoing` | GET | Requests sent by current company |
| `company/access-requests/{id}/accept` | POST | Approve request |
| `company/access-requests/{id}/reject` | POST | Reject request |
| `company/companies/{id}/products` | GET | Peer products (only if approved) |

---

### 4.6 Profile Screen (Company variant — separate UI)

**Requirement:** Maintain a **separate layout** from user profile; display **full company details**.

#### 4.6.1 Company Profile Sections

| Section | Fields (from `CompanyListData` + extensions) |
|---------|-----------------------------------------------|
| Header | Logo, banner, company name |
| Contact | Email, phone, WhatsApp, website |
| Address | Address, city, state, country, pincode |
| Description | Full company description |
| Social | Facebook, Instagram, Twitter, YouTube, LinkedIn |
| Shade cards | List / manage if `shade_card_enabled` |
| Ratings | Average rating, review count (read-only for own) |
| Incoming access requests | Badge count + navigate to requests |
| Account actions | Change language, Privacy, Terms, Logout, Delete |

#### 4.6.2 Differences from User Profile

| User Profile | Company Profile |
|--------------|-----------------|
| Phone only | Full company record |
| Wishlist menu | **Removed** |
| Placeholder avatar | Company logo |
| "Thredo ID" badge | Company ID / registration info |
| No edit company | **Edit company** (future) or read-only v1 |

**File strategy:** `CompanyProfileScreen` (existing) is user-facing browse; create **`CompanyAccountScreen`** or **`CompanySettingsProfileScreen`** for logged-in company's own profile to avoid confusion.

---

## 5. Company Bottom Navigation (Proposed)

| Tab | Screen | Notes |
|-----|--------|-------|
| Home | Company Home (own products) | Same UI as user Home |
| Category | Category (unchanged UI) | Products scoped to own company |
| Companies | **Company List + Approval** | Replaces user "Company" browse tab semantics |
| Profile | **Company Profile UI** | Full company details layout |

**Excluded:** Match tab

```
┌─────────────────────────────────────────┐
│  Home  │ Category │ Companies │ Profile │
└─────────────────────────────────────────┘
         (4 tabs — no Match)
```

---

## 6. Data Model Extensions

### 6.1 LoginData (extend)

| Field | Type | Notes |
|-------|------|-------|
| `role` | string | `user` \| `company` |
| `companyId` | string? | Required when `role == company` |
| `companyName` | string? | Optional display cache |

### 6.2 CompanyAccessRequest (new)

| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Request ID |
| `requesterCompanyId` | UUID | Company A |
| `targetCompanyId` | UUID | Company B |
| `status` | enum | `pending`, `approved`, `rejected` |
| `message` | string? | Optional note from requester |
| `rejectionReason` | string? | Optional from target |
| `createdAt` | datetime | |
| `respondedAt` | datetime? | |

### 6.3 CompanyPeer (new — list item)

| Field | Type | Description |
|-------|------|-------------|
| `company` | CompanyListData | Peer company info |
| `accessStatus` | enum | `none`, `pending`, `approved`, `rejected` |
| `requestId` | UUID? | If pending/rejected |

---

## 7. API Architecture (Proposed)

### 7.1 Namespace Strategy

| Namespace | Used by | Purpose |
|-----------|---------|---------|
| `user/*` | User role | Existing marketplace APIs |
| `company/*` | Company role | Scoped products, peers, access requests, profile |

### 7.2 Auth

- Same OTP flow; `role` and `company_id` returned on verify
- Bearer token scopes requests server-side
- Company token must not access user-only endpoints (wishlist, match-thread) — **403**

### 7.3 Event Logging

Reuse `user/events` or add `company/events` with same body:

```json
{
  "event_type": "product_screen_shot",
  "product_id": "uuid",
  "platform": "ios"
}
```

---

## 8. UI/UX Guidelines

### 8.1 Shared Components (reuse)

- Product grid tile (`AppCachedImage`, resize variants)
- Product filter bottom sheet (hide company filter for company role)
- Product reel container
- Zoomable image / progressive loader
- Category cards
- Company review tiles (peer view only)

### 8.2 Role-Specific Layouts (maintain separately)

| Component | User file | Company file |
|-----------|-----------|--------------|
| Bottom menu | `bottom_menu_screen.dart` | `company_bottom_menu_screen.dart` |
| Home | `home_screen.dart` | `company_home_screen.dart` or parameterized |
| Profile | `profile_screen.dart` | `company_account_screen.dart` |
| Company list | `company_screen.dart` (browse) | `company_peer_list_screen.dart` (approval) |

### 8.3 Visual Consistency

- Brand colors: `#09064A`, `#CEAB8D`, `#E7E3DA`
- Company shell should feel like the same app, not a different product
- Use badges for access status (Pending = amber, Approved = green, Rejected = red)

---

## 9. Security & Permissions

| Rule | Implementation |
|------|----------------|
| Company sees only own products on Home/Category | Server enforces `company_id` from token |
| Peer products only after approval | Server checks `access_requests` table |
| No wishlist / match for company role | UI hidden + API 403 |
| Company A cannot modify Company B data | Read-only peer product detail |
| Token role mismatch | Force logout / re-auth |

---

## 10. Notifications (Recommended)

| Event | Recipient | Message |
|-------|-----------|---------|
| Access request sent | Company B | "Company A requested to view your products" |
| Request approved | Company A | "Company B approved your access request" |
| Request rejected | Company A | "Company B declined your access request" |

*Requires push notification infrastructure (not in current app — mock notifications exist only).*

---

## 11. Implementation Phases

### Phase 1 — Foundation
- Read `role` after OTP; route to correct bottom menu
- Extend `LoginData` with `companyId`
- Add `company/` API config constants
- Company bottom navigation (4 tabs)

### Phase 2 — Scoped Catalog
- Company Home (own products only)
- Category / sub-category with company scope
- Company product reel + restricted detail

### Phase 3 — Peer Access
- Company list with access status badges
- Request / accept / reject workflow
- Approved peer product browsing

### Phase 4 — Company Profile UI
- Dedicated company account profile screen
- Incoming requests management
- Edit company profile (if backend ready)

### Phase 5 — Polish
- Push notifications for access workflow
- Analytics events for company role
- QA, edge cases, rejection re-request policy

---

## 12. Acceptance Criteria (Summary)

| # | Criterion |
|---|-----------|
| 1 | User role experience is unchanged after release |
| 2 | Company user lands on 4-tab shell without Match |
| 3 | Company Home shows only own products with same grid UI |
| 4 | Category screens look identical; products scoped to own company |
| 5 | Product detail hides wishlist, embroidery match for company role |
| 6 | Company list shows peers with access status |
| 7 | Company A can request access to Company B |
| 8 | Company B can accept or reject from profile/requests UI |
| 9 | Approved peers' products are viewable read-only |
| 10 | Company profile screen shows full company details (separate layout) |

---

## 13. Open Questions for Backend / Product

1. Should company Home show **banners**? If yes, company-specific or global?
2. Is **WhatsApp share** allowed for company users on own products?
3. Is **AR Match** allowed for company users (quality check)?
4. Can a rejected company **re-request** immediately or after cooldown?
5. Does company role use the **same OTP login** or separate onboarding?
6. Should company users see **reviews** on their own profile (read-only)?
7. **Product create/edit** in mobile app — in scope for v1 or admin panel only?

---

## 14. Appendix — Current File Map

| Area | Key files |
|------|-----------|
| Navigation | `lib/view/bottomMenu/bottom_menu_screen.dart` |
| Auth | `lib/view/login/`, `lib/view/otpVerification/` |
| Home | `lib/view/home/home_screen.dart`, `home_cubit.dart` |
| Category | `lib/view/category/` |
| Match | `lib/view/threadMatch/thread_match_screen.dart` |
| Company browse | `lib/view/company/company_screen.dart`, `company_profile_screen.dart` |
| Product | `lib/view/productDetail/product_detail_screen.dart`, `product_reel_screen.dart` |
| Profile | `lib/view/profile/profile_screen.dart` |
| API | `lib/app_config.dart`, `lib/api/dio_helper.dart` |
| Models | `lib/model/login_response.dart`, `company_list_response.dart`, `product_list_response.dart` |

---

*End of document*
