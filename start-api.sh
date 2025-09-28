#!/bin/bash

# User Matching Project - Start API Server (Rails)
# This script starts the Rails API server

echo "📡 Starting User Matching API Server..."
echo "======================================"

# Function to cleanup background process on script exit
cleanup() {
    echo ""
    echo "🛑 Stopping API server..."
    kill $API_PID 2>/dev/null
    exit 0
}

# Set up signal handlers for cleanup
trap cleanup SIGINT SIGTERM

# Check if we're in the right directory
if [ ! -d "user-matching-api" ]; then
    echo "❌ Error: Please run this script from the project root directory"
    echo "   Expected directory: user-matching-api/"
    exit 1
fi

# Start the Rails API server
echo "📡 Starting Rails API server..."
cd user-matching-api

# Install dependencies if needed
if [ ! -d "vendor/bundle" ]; then
    echo "📦 Installing dependencies..."
    bundle install
fi

# Start the Rails server
echo "🚀 Starting Rails server..."
rails server -p 3000 &
API_PID=$!

cd ..

echo ""
echo "✅ API server is starting up..."
echo "   📡 API server: http://localhost:3000 (Rails)"
echo ""
echo "Press Ctrl+C to stop the API server"
echo "======================================"

# Wait for the process
wait $API_PID 