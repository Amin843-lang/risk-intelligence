# Risk Intelligence

Geopolitical risk and investment intelligence platform.

## 🌐 Live Demo

Deploy this application to Vercel, Netlify, or any static hosting platform.

### Deploy to Vercel

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https://github.com/Amin843-lang/risk-intelligence)

**Manual Deployment:**
1. Install Vercel CLI: `npm i -g vercel`
2. Run `vercel` in the project root
3. Follow the prompts

Your app will be deployed and accessible at: `https://your-project-name.vercel.app`

### Deploy to Netlify

[![Deploy to Netlify](https://www.netlify.com/img/deploy/button.svg)](https://app.netlify.com/start/deploy?repository=https://github.com/Amin843-lang/risk-intelligence)

**Manual Deployment:**
1. Drag and drop the project folder to [Netlify Drop](https://app.netlify.com/drop)
2. Or install Netlify CLI: `npm install -g netlify-cli`
3. Run `netlify deploy --prod`

### Other Hosting Options

This is a static HTML application and can be deployed anywhere:
- **GitHub Pages**: Enable in repository settings → Pages
- **Cloudflare Pages**: Connect your repository
- **Firebase Hosting**: `firebase deploy`
- **AWS S3**: Upload to an S3 bucket with static website hosting enabled

## 🚀 Quick Start

Simply open `index.html` in your web browser, or serve it with any web server:

```bash
# Using Python
python -m http.server 8000

# Using Node.js
npx serve

# Using PHP
php -S localhost:8000
```

Then visit `http://localhost:8000` in your browser.

## 📁 Project Structure

```
risk-intelligence/
├── index.html          # Main application file (root level for deployment)
├── risk-intelligence/  # Original subdirectory (kept for compatibility)
│   └── index.html
├── vercel.json        # Vercel deployment configuration
├── README.md
└── LICENSE
```

## 🛠️ Technical Details

- **Framework**: Vanilla JavaScript (no dependencies)
- **Styling**: Embedded CSS with responsive design
- **Deployment**: Static HTML - works on any web server
- **Browser Support**: All modern browsers (Chrome, Firefox, Safari, Edge)

## 📝 Features

- Interactive dashboard with global risk overview
- Real-time search and filtering
- Regional risk analysis for 8 major world regions
- Investment insights and recommendations
- Responsive design for mobile and desktop
- Auto-updating timestamp display
