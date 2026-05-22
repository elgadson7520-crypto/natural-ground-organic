# Natural Ground Organics — Placeholder Site

A single-page informational/preview site for Natural Ground Organics (Serena & Jeremiah Watts). This is **not a live e-commerce store** — it's a placeholder to establish the brand presence online while a real storefront is set up separately.

## What's in this project

- `index.html` — the entire site (HTML + CSS + inline SVG graphics, all in one file)
- `images/logo.jpg` — official Natural Ground Organics brand mark (used in the header and footer)
- `images/` — drop replacement product photos here using the filenames referenced in `index.html`
- `vercel.json` — hosting configuration (caching, security headers)
- `README.md` — this file

The site's color palette (deep olive, warm gold, coconut brown, cream parchment) is pulled directly from the brand logo so the whole page feels cohesive with the mark.

## How to update content

### Swap product photos (when you have real ones)

1. Drop replacement JPGs into the `images/` folder, using the filenames already referenced in `index.html` (see the prompt or open `index.html` and search for `images/`).
2. Commit and push to git.
3. Vercel auto-deploys in ~30 seconds.

### Update text or prices

1. Open `index.html` in any text editor.
2. Find the section you want to change (use Ctrl/Cmd-F to search the visible text).
3. Save, commit, and push. Vercel auto-deploys.

## Custom domain

When you're ready to use `naturalgroundorganics.com` (or similar):

1. **Register the domain** at a registrar like Namecheap, Cloudflare, or Google Domains. Cost is roughly $10–15/year — this is the only real recurring cost; Vercel hosting is free for this kind of static site.
2. **Add the domain in Vercel**: project settings → Domains → Add.
3. **Update DNS** at the registrar with the records Vercel provides.
4. **SSL** is provisioned automatically — usually live within a few minutes.

## Important: this is a placeholder, not a store

When you're ready to actually sell, you'll need a real e-commerce platform. For kratom products specifically:

- **Shopify** is the most common platform.
- You'll need a high-risk payment processor (Inflow, PaymentCloud, etc.) because Stripe and Square block kratom transactions.
- This Vercel-hosted site can serve as a "coming soon" / informational landing page that redirects to the Shopify store once it's live.

## Technical contact

For changes to this Vercel-hosted preview site, reach out to whoever set it up. Anything beyond text and image swaps (a real storefront, payment processing, custom domain DNS) is a separate project.

## Stack

- Static HTML/CSS/JS — no build step, no dependencies
- Hosted on Vercel (Hobby tier — free)
- Inline SVG graphics keep the site self-contained and fast
