import streamlit as st
import requests

st.title("Resume Summarizer")

full_name = st.text_input("Full Name")
uploaded_file = st.file_uploader("Upload your resume", type=["pdf", "docx", "txt"])

if uploaded_file:
    files = {"file": uploaded_file.getvalue()}
    response = requests.post("http://backend-service:8000/summarize", files=files)

    if response.status_code == 200:
        summary = response.json().get("summary", "No summary available")
        st.text_area("Summary", summary, height=200)
    else:
        st.error("Error generating summary. Please try again.")