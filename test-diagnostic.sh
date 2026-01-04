echo "=================================================="
echo "  Personal Finance Tracker - Diagnostic Test"
echo "=================================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
PASSED=0
FAILED=0

# Function to print test results
print_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓ PASS${NC} - $2"
        ((PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC} - $2"
        ((FAILED++))
    fi
}

echo "======================================"
echo "1. Checking Directory Structure"
echo "======================================"
echo ""

# Check backend directory
if [ -d "backend" ]; then
    print_result 0 "Backend directory exists"
else
    print_result 1 "Backend directory NOT found"
fi

# Check frontend directory
if [ -d "frontend" ]; then
    print_result 0 "Frontend directory exists"
else
    print_result 1 "Frontend directory NOT found"
fi

echo ""
echo "======================================"
echo "2. Checking Backend Files"
echo "======================================"
echo ""

BACKEND_FILES=("backend/app.py" "backend/models.py" "backend/auth.py" "backend/config.py" "backend/requirements.txt" "backend/.env" "backend/routes/__init__.py" "backend/routes/users.py" "backend/routes/transactions.py")

for file in "${BACKEND_FILES[@]}"; do
    if [ -f "$file" ]; then
        print_result 0 "File exists: $file"
    else
        print_result 1 "File missing: $file"
    fi
done

echo ""
echo "======================================"
echo "3. Checking Frontend Files"
echo "======================================"
echo ""

FRONTEND_FILES=("frontend/package.json" "frontend/.env.local" "frontend/src/App.js" "frontend/src/index.js" "frontend/src/services/api.js" "frontend/src/components/Login.jsx" "frontend/src/components/Dashboard.jsx" "frontend/src/components/TransactionForm.jsx" "frontend/src/components/TransactionList.jsx")

for file in "${FRONTEND_FILES[@]}"; do
    if [ -f "$file" ]; then
        print_result 0 "File exists: $file"
    else
        print_result 1 "File missing: $file"
    fi
done

echo ""
echo "======================================"
echo "4. Checking Python Dependencies"
echo "======================================"
echo ""

if command -v python3 &> /dev/null; then
    print_result 0 "Python3 is installed ($(python3 --version))"
else
    print_result 1 "Python3 is NOT installed"
fi

if command -v pip &> /dev/null || command -v pip3 &> /dev/null; then
    print_result 0 "pip is installed"
else
    print_result 1 "pip is NOT installed"
fi

echo ""
echo "======================================"
echo "5. Checking Node.js Dependencies"
echo "======================================"
echo ""

if command -v node &> /dev/null; then
    print_result 0 "Node.js is installed ($(node --version))"
else
    print_result 1 "Node.js is NOT installed"
fi

if command -v npm &> /dev/null; then
    print_result 0 "npm is installed ($(npm --version))"
else
    print_result 1 "npm is NOT installed"
fi

echo ""
echo "======================================"
echo "6. Checking Backend Configuration"
echo "======================================"
echo ""

if [ -f "backend/.env" ]; then
    if grep -q "SECRET_KEY" backend/.env; then
        print_result 0 "SECRET_KEY found in .env"
    else
        print_result 1 "SECRET_KEY missing in .env"
    fi
    
    if grep -q "JWT_SECRET_KEY" backend/.env; then
        print_result 0 "JWT_SECRET_KEY found in .env"
    else
        print_result 1 "JWT_SECRET_KEY missing in .env"
    fi
else
    print_result 1 "Backend .env file not found"
fi

echo ""
echo "======================================"
echo "7. Checking Frontend Configuration"
echo "======================================"
echo ""

if [ -f "frontend/.env.local" ]; then
    if grep -q "REACT_APP_API_URL" frontend/.env.local; then
        API_URL=$(grep REACT_APP_API_URL frontend/.env.local | cut -d '=' -f2)
        print_result 0 "REACT_APP_API_URL found: $API_URL"
    else
        print_result 1 "REACT_APP_API_URL missing in .env.local"
    fi
else
    print_result 1 "Frontend .env.local file not found"
fi

echo ""
echo "======================================"
echo "8. Checking if Backend is Running"
echo "======================================"
echo ""

if curl -s http://localhost:5000/api/health > /dev/null 2>&1; then
    RESPONSE=$(curl -s http://localhost:5000/api/health)
    print_result 0 "Backend is responding on port 5000"
    echo "   Response: $RESPONSE"
else
    print_result 1 "Backend is NOT responding on port 5000"
    echo -e "   ${YELLOW}→ Make sure to run: cd backend && python app.py${NC}"
fi

echo ""
echo "======================================"
echo "9. Checking if Frontend is Running"
echo "======================================"
echo ""

if curl -s http://localhost:3000 > /dev/null 2>&1; then
    print_result 0 "Frontend is responding on port 3000"
else
    print_result 1 "Frontend is NOT responding on port 3000"
    echo -e "   ${YELLOW}→ Make sure to run: cd frontend && npm start${NC}"
fi

echo ""
echo "======================================"
echo "10. Testing Backend Endpoints"
echo "======================================"
echo ""

# Test health endpoint
if curl -s http://localhost:5000/api/health > /dev/null 2>&1; then
    HEALTH_RESPONSE=$(curl -s http://localhost:5000/api/health)
    if echo "$HEALTH_RESPONSE" | grep -q "healthy"; then
        print_result 0 "Health endpoint working"
    else
        print_result 1 "Health endpoint not returning expected response"
    fi
else
    print_result 1 "Cannot reach health endpoint"
fi

# Test CORS
CORS_TEST=$(curl -s -H "Origin: http://localhost:3000" \
    -H "Access-Control-Request-Method: POST" \
    -H "Access-Control-Request-Headers: Content-Type" \
    -X OPTIONS \
    http://localhost:5000/api/users/login \
    -I 2>&1 | grep -i "access-control-allow-origin")

if [ ! -z "$CORS_TEST" ]; then
    print_result 0 "CORS is configured correctly"
else
    print_result 1 "CORS may not be configured correctly"
fi

echo ""
echo "======================================"
echo "11. Testing Database"
echo "======================================"
echo ""

if [ -f "backend/finance.db" ]; then
    print_result 0 "Database file exists (backend/finance.db)"
    
    # Check if database is accessible
    if command -v sqlite3 &> /dev/null; then
        TABLE_COUNT=$(sqlite3 backend/finance.db "SELECT count(*) FROM sqlite_master WHERE type='table';" 2>/dev/null)
        if [ ! -z "$TABLE_COUNT" ] && [ "$TABLE_COUNT" -gt 0 ]; then
            print_result 0 "Database has $TABLE_COUNT tables"
        else
            print_result 1 "Database exists but may be empty"
        fi
    else
        echo -e "   ${YELLOW}! INFO${NC} - sqlite3 not installed, skipping detailed DB check"
    fi
else
    print_result 1 "Database file not found (will be created on first run)"
fi

echo ""
echo "======================================"
echo "12. Checking Package Dependencies"
echo "======================================"
echo ""

# Check if node_modules exists
if [ -d "frontend/node_modules" ]; then
    print_result 0 "Frontend node_modules installed"
else
    print_result 1 "Frontend dependencies NOT installed"
    echo -e "   ${YELLOW}→ Run: cd frontend && npm install${NC}"
fi

# Check if Python packages are installed
if [ -f "backend/requirements.txt" ]; then
    cd backend
    MISSING_PACKAGES=0
    while IFS= read -r package; do
        PKG_NAME=$(echo $package | cut -d'=' -f1)
        if ! python3 -c "import $PKG_NAME" 2>/dev/null && ! python3 -c "import ${PKG_NAME//-/_}" 2>/dev/null; then
            MISSING_PACKAGES=$((MISSING_PACKAGES + 1))
        fi
    done < requirements.txt
    cd ..
    
    if [ $MISSING_PACKAGES -eq 0 ]; then
        print_result 0 "All Python packages appear to be installed"
    else
        print_result 1 "$MISSING_PACKAGES Python package(s) may be missing"
        echo -e "   ${YELLOW}→ Run: cd backend && pip install -r requirements.txt${NC}"
    fi
fi

echo ""
echo "======================================"
echo "           TEST SUMMARY"
echo "======================================"
echo ""
echo -e "Tests Passed: ${GREEN}$PASSED${NC}"
echo -e "Tests Failed: ${RED}$FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed! Your application should be working correctly.${NC}"
    echo ""
    echo "To access your application:"
    echo "1. Backend should be running at: http://localhost:5000"
    echo "2. Frontend should be accessible at: http://localhost:3000"
    echo ""
else
    echo -e "${RED}✗ Some tests failed. Please fix the issues above.${NC}"
    echo ""
    echo "Common fixes:"
    echo "1. Install backend dependencies: cd backend && pip install -r requirements.txt"
    echo "2. Install frontend dependencies: cd frontend && npm install"
    echo "3. Start backend: cd backend && python app.py"
    echo "4. Start frontend: cd frontend && npm start"
    echo ""
fi

echo "======================================"
echo "     Additional Information"
echo "======================================"
echo ""

# Show running processes
echo "Checking for running Flask/Node processes:"
if pgrep -f "flask" > /dev/null || pgrep -f "app.py" > /dev/null; then
    echo -e "${GREEN}✓${NC} Flask process is running"
    ps aux | grep -E "flask|app.py" | grep -v grep
else
    echo -e "${YELLOW}!${NC} No Flask process found"
fi

if pgrep -f "node.*react-scripts" > /dev/null; then
    echo -e "${GREEN}✓${NC} React development server is running"
else
    echo -e "${YELLOW}!${NC} No React development server found"
fi

echo ""
echo "======================================"
echo "Script completed!"
echo "======================================"
