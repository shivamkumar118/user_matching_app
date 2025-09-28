#!/bin/bash

# User Matching Project - Start Web Server (Vue.js)
# This script starts the Vue.js web server

echo "🌐 Starting User Matching Web Server..."
echo "======================================"

# Function to cleanup background process on script exit
cleanup() {
    echo ""
    echo "🛑 Stopping web server..."
    kill $WEB_PID 2>/dev/null
    exit 0
}

# Set up signal handlers for cleanup
trap cleanup SIGINT SIGTERM

# Check if we're in the right directory
if [ ! -d "user-matching-web" ]; then
    echo "❌ Error: Please run this script from the project root directory"
    echo "   Expected directory: user-matching-web/"
    exit 1
fi

# Start the Vue.js web server
echo "🌐 Starting Vue.js web server..."
cd user-matching-web

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Start the development server
echo "🚀 Starting development server..."
npm run dev &
WEB_PID=$!

cd ..

echo ""
echo "✅ Web server is starting up..."
echo "   🌐 Web server: http://localhost:5173 (Vue.js/Vite)"
echo ""
echo "Press Ctrl+C to stop the web server"
echo "======================================"

# Wait for the process
wait $WEB_PID 