# Risk Intelligence

Geopolitical risk and investment intelligence platform

## Overview

Risk Intelligence is a comprehensive platform for analyzing geopolitical risks and making informed investment decisions. The platform provides real-time analysis, data-driven insights, and strategic assessments to help navigate the complex world of global markets.

## Features

- 📊 **Risk Analysis**: Comprehensive analysis of geopolitical events and their market impact
- 🌐 **Global Coverage**: Monitor developments across all major regions and emerging markets
- 💡 **Strategic Insights**: Data-driven recommendations for portfolio optimization
- ⚡ **Real-time Updates**: Instant alerts on critical geopolitical events
- 📈 **Market Intelligence**: Advanced analytics combining geopolitical factors with market trends
- 🔒 **Secure Platform**: Enterprise-grade security for your data

## Deployment

This project is configured for deployment on [Vercel](https://vercel.com).

### Deploy to Vercel

1. **Fork or clone this repository**

2. **Connect to Vercel**:
   - Go to [vercel.com](https://vercel.com)
   - Click "New Project"
   - Import this repository
   - Vercel will automatically detect the configuration from `vercel.json`

3. **Deploy**:
   - Click "Deploy"
   - Your site will be live at `https://your-project.vercel.app`

### Configuration

The `vercel.json` file contains the deployment configuration:
- Static site deployment using `@vercel/static`
- All routes redirect to `index.html` for single-page application behavior

### Local Development

To view the site locally:

```bash
# Option 1: Using Python's built-in server
python3 -m http.server 8000

# Option 2: Using Node.js http-server
npx http-server

# Option 3: Using PHP
php -S localhost:8000
```

Then open `http://localhost:8000` in your browser.

## Project Structure

```
risk-intelligence/
├── index.html      # Main HTML file
├── vercel.json     # Vercel deployment configuration
├── README.md       # Project documentation
├── LICENSE         # License file
└── .gitignore      # Git ignore rules
```

## License

This project is open source. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
