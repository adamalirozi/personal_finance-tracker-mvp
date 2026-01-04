# Personal Finance Tracker MVP

A full-stack personal finance tracking application built with Flask (backend) and React (frontend). Track your income and expenses, visualize spending patterns, set budgets, and gain insights into your financial habits.

## Features

### Core Features
- 🔐 **User Authentication** - Secure register/login with JWT tokens
- 💰 **Transaction Management** - Add, edit, and delete financial transactions
- 📊 **Financial Summary** - Real-time overview of income, expenses, and balance
- 🏷️ **Category Tracking** - Organize transactions by custom categories
- 📅 **Date-based Tracking** - Track transactions with precise timestamps

### Advanced Features
- 📈 **Data Visualization** - Interactive charts and graphs showing:
  - Expenses breakdown by category
  - Monthly income vs expense trends
  - Top spending categories
- 🔍 **Smart Filtering** - Filter transactions by:
  - Category
  - Transaction type (income/expense)
  - Date range
- 💾 **CSV Export** - Download all transactions in spreadsheet format
- 🎯 **Budget Tracking** - Set monthly budgets per category with:
  - Real-time spending monitoring
  - Progress bars with color-coded alerts
  - Automatic spent/remaining calculations
- 📊 **Analytics Dashboard** - Gain insights into spending patterns and trends

## Tech Stack

### Backend
- Flask (Python web framework)
- Flask-SQLAlchemy (ORM)
- Flask-JWT-Extended (Authentication)
- Flask-CORS (Cross-origin resource sharing)
- SQLite (Database)
- bcrypt (Password hashing)

### Frontend
- React 18 (UI library)
- Axios (HTTP client)
- CSS-in-JS styling
- Responsive design

## Project Structure

```
finance-tracker-mvp/
├── backend/
│   ├── app.py                      # Main Flask application
│   ├── models.py                   # Database models (User, Transaction, Budget)
│   ├── auth.py                     # Authentication logic
│   ├── config.py                   # Configuration settings
│   ├── requirements.txt            # Python dependencies
│   ├── .env                        # Environment variables
│   └── routes/
│       ├── __init__.py
│       ├── transactions.py         # Transaction CRUD + filtering + export
│       ├── users.py                # User registration/login
│       └── budgets.py              # Budget management
├── frontend/
│   ├── package.json
│   ├── .env.local                  # Frontend environment variables
│   ├── public/
│   │   └── index.html
│   └── src/
│       ├── index.js
│       ├── App.js
│       ├── App.css
│       ├── components/
│       │   ├── Dashboard.jsx       # Main dashboard with tabs
│       │   ├── TransactionForm.jsx # Add/edit transactions
│       │   ├── TransactionList.jsx # Display transactions
│       │   ├── Login.jsx           # Authentication UI
│       │   ├── FilterBar.jsx       # Transaction filters
│       │   ├── Charts.jsx          # Data visualizations
│       │   └── BudgetTracker.jsx   # Budget management
│       └── services/
│           └── api.js              # API integration
└── README.md
```

## Installation & Setup

### Prerequisites
- Python 3.8+
- Node.js 14+
- npm or yarn

### Backend Setup

1. Navigate to the backend directory:
```bash
cd backend
```

2. Create a virtual environment (recommended):
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

4. Configure environment variables:
Edit the `.env` file and update the secret keys:
```env
SECRET_KEY=your-secret-key-here
JWT_SECRET_KEY=your-jwt-secret-key-here
DATABASE_URL=sqlite:///finance.db
```

5. Run the Flask application:
```bash
python app.py
```

The backend will run on `http://localhost:5000`

### Frontend Setup

1. Navigate to the frontend directory:
```bash
cd frontend
```

2. Install dependencies:
```bash
npm install
```

3. Configure environment variables:
The `.env.local` file is already configured to point to `http://localhost:5000/api`

4. Start the React development server:
```bash
npm start
```

The frontend will run on `http://localhost:3000`

## Usage Guide

### Getting Started
1. **Register**: Create a new account with username, email, and password
2. **Login**: Access your account using your credentials

### Transactions Tab
- **Add Transaction**: Fill in amount, category, description, type (income/expense), and date
- **View Transactions**: See all transactions in a list with latest first
- **Edit**: Click the "Edit" button on any transaction to modify it
- **Delete**: Click "Delete" to remove a transaction (with confirmation)
- **Filter**: Use the filter bar to narrow down transactions by:
  - Category dropdown
  - Type (All/Income/Expense)
  - Start and end dates
- **Export**: Click "📥 Export CSV" to download all transactions

### Analytics Tab
- **Category Breakdown**: Visual representation of spending by category with percentages
- **Monthly Trends**: Bar chart comparing income vs expenses month-by-month
- **Top Categories**: Ranked list of your top 5 spending categories
- **Date Filtering**: Apply date filters to analyze specific time periods

### Budgets Tab
- **Add Budget**: 
  - Click "+ Add Budget"
  - Enter category name and budget amount
  - Budgets are set per month (current month by default)
- **Monitor Progress**: 
  - View spent amount vs budget amount
  - See remaining budget
  - Progress bar shows percentage used with color coding:
    - 🟢 Green: Under 70% (safe)
    - 🟡 Yellow: 70-90% (warning)
    - 🔴 Red: Over 90% (alert)
- **Delete Budget**: Click the × button to remove a budget

### Financial Summary
- View at-a-glance totals for:
  - Total Income (green)
  - Total Expenses (red)
  - Current Balance (green if positive, red if negative)

## API Endpoints

### Authentication
- `POST /api/users/register` - Register new user
- `POST /api/users/login` - Login user

### Transactions
- `GET /api/transactions/` - Get all user transactions
  - Query params: `category`, `type`, `start_date`, `end_date`
- `POST /api/transactions/` - Create new transaction
- `PUT /api/transactions/<id>` - Update transaction
- `DELETE /api/transactions/<id>` - Delete transaction
- `GET /api/transactions/summary` - Get financial summary
  - Query params: `start_date`, `end_date`
- `GET /api/transactions/analytics` - Get analytics data
  - Query params: `start_date`, `end_date`
- `GET /api/transactions/categories` - Get all unique categories
- `GET /api/transactions/export` - Export transactions as CSV

### Budgets
- `GET /api/budgets/` - Get budgets for a specific month
  - Query params: `month`, `year`
- `POST /api/budgets/` - Create or update budget
- `DELETE /api/budgets/<id>` - Delete budget

## Security Features

- **Password Security**: bcrypt hashing with salt
- **JWT Authentication**: Token-based authentication with 24-hour expiry
- **Protected Routes**: All transaction and budget endpoints require valid JWT
- **CORS Protection**: Configured for secure cross-origin requests
- **Input Validation**: Server-side validation of all inputs
- **SQL Injection Protection**: SQLAlchemy ORM prevents SQL injection

## Database Schema

### Users Table
- `id` - Primary key
- `username` - Unique username
- `email` - Unique email address
- `password_hash` - Hashed password
- `created_at` - Account creation timestamp

### Transactions Table
- `id` - Primary key
- `user_id` - Foreign key to users
- `amount` - Transaction amount (float)
- `category` - Category name (string)
- `description` - Optional description
- `transaction_type` - 'income' or 'expense'
- `date` - Transaction date

### Budgets Table
- `id` - Primary key
- `user_id` - Foreign key to users
- `category` - Category name
- `amount` - Budget amount (float)
- `month` - Month (1-12)
- `year` - Year (YYYY)
- `created_at` - Budget creation timestamp

## Troubleshooting

### Backend Issues
- **Database not created**: Database is auto-created on first run
- **JWT errors**: Check that JWT_SECRET_KEY is set in `.env`
- **Port already in use**: Change port in `app.py` or kill existing process

### Frontend Issues
- **CORS errors**: Ensure backend CORS is configured for `http://localhost:3000`
- **API connection failed**: Verify backend is running on port 5000
- **Login/Register not working**: Check browser console for errors

### Data Issues
- **Transactions not showing**: Check filters - click "Reset Filters"
- **Charts empty**: Add more transactions with different categories
- **Budget not calculating**: Ensure transaction categories match budget category exactly

## Performance Considerations

- **Database**: SQLite is suitable for single-user or small-scale use. For production, consider PostgreSQL or MySQL
- **Caching**: Consider implementing Redis for session management in production
- **File Storage**: For large datasets, implement pagination on transaction list
- **Security**: Use environment variables for all secrets, never commit `.env` file

## Future Enhancements

- 🔄 Recurring transactions with automatic scheduling
- 💱 Multi-currency support with real-time exchange rates
- 📱 Mobile responsive design improvements
- 🔔 Budget alerts and notifications
- 📧 Email reports (weekly/monthly summaries)
- 🎨 Customizable dashboard themes
- 👥 Family/shared accounts with permissions
- 🔗 Bank account integration via Plaid
- 🤖 AI-powered spending insights and recommendations
- 📤 Export to multiple formats (PDF, Excel)
- 🗃️ Attachment support for receipts
- 🔍 Advanced search with full-text search
- 📊 Custom report generation
- 🎯 Savings goals tracking

## Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please ensure:
- Code follows existing style conventions
- All tests pass
- New features include appropriate tests
- Documentation is updated

## License

This project is open source and available under the MIT License.

## Support

For issues or questions:
- Open an issue on the project repository
- Check existing issues for solutions
- Provide detailed error messages and steps to reproduce

## Acknowledgments

- Built with Flask and React
- Icons from Unicode emoji set
- Inspired by modern finance tracking applications

## Version History

- **v2.0** (Current) - Added analytics, budgets, filtering, and CSV export
- **v1.0** - Initial MVP with basic transaction tracking

---

**Happy Tracking! 💰📊**
