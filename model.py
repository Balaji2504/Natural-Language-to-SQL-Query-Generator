from langchain.prompts import ChatPromptTemplate
from langchain_community.chat_models import ChatOllama

# Initialize LangChain with Ollama model (e.g., Mistral or Llama2)
chat_model = ChatOllama(model="mistral")  # Replace 'mistral' with any Ollama-compatible model

# Prompt template for converting natural language to SQL
prompt_template = ChatPromptTemplate.from_template(
    """
    You are an expert SQL assistant. Convert the given natural language question into a valid MySQL query.
    Schema:
    - StudentsMaster: StudentName, Gender, DOB, FatherName, MotherName, FathersOccupation, FathersIncome, BloodGroup, Address, City, State, DateOfJoining, DateOfRecordCreation, UniqueStudentRegNo
    - StudentsMarksheet : UniqueStudentRegNo, Class, Section, TestTerm, Tamil, English, Maths, Science, SocialScience, Total, Average, Grade

    Question: {question}
    SQL Query:
    """
)

def generate_sql_query(question: str) -> str:
    """Generate SQL query from natural language question using Ollama."""
    prompt = prompt_template.format_prompt(question=question)
    response = chat_model.predict(prompt.to_string())
    return response.strip()



