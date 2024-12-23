from fastapi import FastAPI, HTTPException, Request
from pydantic import BaseModel
from fastapi.responses import HTMLResponse
from fastapi.middleware.cors import CORSMiddleware
from db import execute_query
from model import generate_sql_query
from fastapi.staticfiles import StaticFiles
from fastapi import FastAPI

# Initialize FastAPI app
app = FastAPI()

# Add CORS middleware for frontend communication
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins for simplicity
    allow_credentials=True,
    allow_methods=["*"],  # Allow all HTTP methods
    allow_headers=["*"],
)

# Serve static files (frontend)
app.mount("/static", StaticFiles(directory="static"), name="static")

@app.get("/", response_class=HTMLResponse)
async def root():
    with open("static/index.html", "r") as file:
        html_content = file.read()
    return HTMLResponse(content=html_content)

# Request model for querying
class QueryRequest(BaseModel):
    question: str

# Response model with columns and results
class QueryResponse(BaseModel):
    query: str
    columns: list
    result: list

@app.post("/query", response_model=QueryResponse)
async def query_database(request: QueryRequest):
    """
    Endpoint to handle natural language queries and return SQL results.
    """
    try:
        # Convert the natural language question to SQL query
        sql_query = generate_sql_query(request.question)
        print(f"Generated SQL Query: {sql_query}")  # Debugging

        # Execute the query and fetch results
        result, columns = execute_query(sql_query, return_columns=True)

        return QueryResponse(query=sql_query, columns=columns, result=result)

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))