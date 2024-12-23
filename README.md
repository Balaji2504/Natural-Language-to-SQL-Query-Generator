# Natural Language to SQL Query Generator

## Description
This project is a web application that allows users to convert natural language questions into SQL queries and execute them on a MySQL database. By integrating an AI model (Mistral via Ollama), the app makes querying databases intuitive and accessible, even for non-technical users.

---

## Key Features
1. **AI-Powered Query Generation**
   - Automatically converts natural language questions into valid SQL queries based on a predefined schema.
2. **Dynamic Query Execution**
   - Executes the generated SQL queries on a MySQL database and retrieves the results.
3. **User-Friendly Interface**
   - Simple frontend to input queries and view results in an intuitive format.
4. **Secure and Scalable API**
   - Backend powered by FastAPI ensures efficient and secure processing.
5. **CORS Support**
   - Enables seamless frontend-backend interaction.

---

## Technology Stack
### Backend:
- **FastAPI**: API framework for processing requests.
- **LangChain**: For handling prompt templates and AI interactions.
- **ChatOllama**: AI model integration for natural language to SQL conversion.

### AI Model:
- **Mistral**: A powerful language model accessed via the Ollama framework.

### Database:
- **MySQL**: The relational database used for executing SQL queries.

### Frontend:
- **HTML**: Simple static frontend served via FastAPI.

---

## Database Schema
The application uses the following database schema:

### Table 1: `StudentsMaster`
| Column Name           | Data Type |
|-----------------------|-----------|
| StudentName           | VARCHAR   |
| Gender                | VARCHAR   |
| DOB                   | DATE      |
| FatherName            | VARCHAR   |
| MotherName            | VARCHAR   |
| FathersOccupation     | VARCHAR   |
| FathersIncome         | FLOAT     |
| BloodGroup            | VARCHAR   |
| Address               | TEXT      |
| City                  | VARCHAR   |
| State                 | VARCHAR   |
| DateOfJoining         | DATE      |
| DateOfRecordCreation  | DATE      |
| UniqueStudentRegNo    | INT       |

### Table 2: `StudentsMarksheet`
| Column Name           | Data Type |
|-----------------------|-----------|
| UniqueStudentRegNo    | INT       |
| Class                 | VARCHAR   |
| Section               | VARCHAR   |
| TestTerm              | VARCHAR   |
| Tamil                 | INT       |
| English               | INT       |
| Maths                 | INT       |
| Science               | INT       |
| SocialScience         | INT       |
| Total                 | INT       |
| Average               | FLOAT     |
| Grade                 | VARCHAR   |

---

## Installation and Setup

### Prerequisites
1. Python 3.8 or higher installed.
2. MySQL database setup with the schema mentioned above.
3. Node.js (for running Ollama locally if required).

### Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/natural-language-sql-generator.git
   cd natural-language-sql-generator
   ```

2. **Install Python dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Set up the database:**
   - Create a MySQL database and populate it with the provided schema.

4. **Configure database settings:**
   - Update the MySQL connection details in `db.py`.

5. **Start the application:**
   ```bash
   uvicorn main:app --reload
   ```

6. **Access the application in your browser:**
   - Open [http://127.0.0.1:8000/](http://127.0.0.1:8000/).

---

## Usage
1. Open the application in your browser.
2. Input a natural language question in the provided field. Example:
   - "What are the details of students with an average above 90?"
3. View the SQL query and the corresponding results from the database.

---

## Project Structure
```
natural-language-sql-generator/
├── db.py                 # Database connection and execution logic
├── model.py              # AI model for query generation
├── main.py               # FastAPI backend logic
├── static/
│   ├── index.html        # Frontend HTML file
├── requirements.txt      # Python dependencies
├── README.md             # Project documentation
```

---

## Acknowledgments
- **LangChain**: For seamless prompt and model interaction.
- **ChatOllama**: For enabling integration with advanced language models.
- **FastAPI**: For building a robust and scalable backend.
- **MySQL**: For providing a reliable relational database platform.

---

## License
This project is licensed under the MIT License.
