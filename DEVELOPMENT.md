# Development Guide - Auto-Reload & Hot Reloading

## 🚀 Enhanced Development Experience

Your application now includes automatic compilation and reloading for seamless development.

## Available Development Commands

### **Primary Development Command**
```bash
npm run dev
```
- Starts both client and server with hot reloading
- Client auto-reloads on React component changes
- Server auto-restarts on API/backend changes
- Watches for changes in JS, JSON, SQL, and ENV files

### **Advanced Options**

```bash
# Development with debugging enabled
npm run dev:debug

# Watch mode with continuous building
npm run watch

# Client only with hot reloading
npm run client:dev

# Server only with auto-restart
npm run server:dev
```

## VS Code Tasks

Use **Ctrl+Shift+P** → **Tasks: Run Task** and select:

- **Start Development Server** - Standard development mode
- **Development with Debug** - With debugging enabled
- **Watch Mode (Auto-compile)** - Continuous building
- **Start Client Only** - Client development only
- **Start Server Only** - Server development only

## What Auto-Reloads

### **Client (React)**
- ✅ Component changes
- ✅ CSS/styling changes
- ✅ Configuration changes
- ✅ Environment variable changes
- ✅ Fast Refresh enabled for instant updates

### **Server (Node.js)**
- ✅ API route changes (`/routes`)
- ✅ Controller changes (`/controllers`)
- ✅ Database model changes (`/models`)
- ✅ Database connection changes (`/db`)
- ✅ Environment changes (`.env`)
- ✅ SQL file changes (migrations/seeds)

## Development Workflow

1. **Start Development**: `npm run dev`
2. **Make Changes**: Edit any file
3. **See Changes**: 
   - **Frontend**: Instant refresh in browser
   - **Backend**: Automatic server restart
4. **Debug**: Use `npm run dev:debug` for debugging

## File Watching

The system watches these file types:
- `.js` - JavaScript files
- `.json` - Configuration files
- `.sql` - Database files
- `.env` - Environment files
- `.css` - Stylesheets (React handles)
- `.jsx` - React components

## Troubleshooting

### **Changes Not Detected?**
- Save the file (Ctrl+S)
- Check terminal for error messages
- Restart development server: `rs` + Enter

### **Port Conflicts?**
- Client: http://localhost:3000
- Server: http://localhost:5000
- Change ports in environment files if needed

### **Slow Reloading?**
- Close unnecessary browser tabs
- Check system resources
- Use `npm run client:dev` for client-only development

## Production Building

```bash
# Build for production
npm run client:build

# Build with file watching (development)
npm run client:build:watch
```

## Benefits

✅ **No Manual Restarts** - Everything reloads automatically
✅ **Fast Development** - See changes instantly
✅ **Error Detection** - Immediate feedback on issues  
✅ **Debug Ready** - Built-in debugging support
✅ **File Watching** - Monitors all relevant file types
