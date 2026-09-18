# Threado Landing Page

Professional marketing site for **Threado** by Thredo — ready to host on your domain for Google Play Console submission.

## What's included

| File | Purpose |
|------|---------|
| `index.html` | Main landing page (About, Features, How It Works, Gallery, Contact, Download) |
| `privacy.html` | Privacy Policy (required for Play Console) |
| `terms.html` | Terms & Conditions |
| `css/styles.css` | Responsive styles matching app branding |
| `js/main.js` | Mobile nav, scroll effects |
| `assets/` | App icon, logo, optimized images, Poppins fonts |

## URLs for Google Play Console

After deploying to your domain (example: `thredo.com`), use these URLs:

- **Website:** `https://thredo.com/`
- **Privacy policy:** `https://thredo.com/privacy.html`
- **Terms:** `https://thredo.com/terms.html`
- **Support email:** `support@thredo.com`

## Quick preview locally

```bash
cd website
python3 -m http.server 8080
```

Open [http://localhost:8080](http://localhost:8080)

## Deploy options

### Option A — Any web host (cPanel, VPS, shared hosting)

1. Upload the entire `website/` folder contents to your domain's public root (`public_html`, `www`, or `/var/www/html`).
2. Ensure `index.html` is the default document.
3. Point your domain DNS A/CNAME record to the server.
4. Enable HTTPS (Let's Encrypt or your host's SSL).

### Option B — Netlify (drag & drop)

1. Go to [netlify.com](https://www.netlify.com) and create a site.
2. Drag the `website` folder into the deploy area.
3. Add your custom domain in **Domain settings** and update DNS.

Optional `netlify.toml` is included for clean URLs.

### Option C — Vercel

```bash
cd website
npx vercel --prod
```

### Option D — GitHub Pages

1. Push the `website/` folder to a repo (or use a `gh-pages` branch).
2. In repo **Settings → Pages**, set source to that folder.
3. Add a custom domain under Pages settings.

## Before going live — checklist

- [ ] Replace placeholder Play Store link if your listing URL differs
- [ ] Confirm `support@thredo.com` is active and monitored
- [ ] Add real app screenshots to `assets/images/` if available (update gallery in `index.html`)
- [ ] Update `og:url` in `index.html` to your live domain
- [ ] Test all three pages on mobile and desktop
- [ ] Verify HTTPS works (Google Play requires a secure privacy policy URL)

## App details

- **App name:** Threado
- **Developer:** Thredo
- **Package:** `com.app.thredo`
- **Play Store:** `https://play.google.com/store/apps/details?id=com.app.thredo`

## Brand colors

- Primary: `#E7E3DA`
- Accent: `#CEAB8D`
- Navy: `#09064A`
