# Backend Setup Instructions

## Create and Activate Virtual Environment

```
python -m venv venv
```

For Window

```
.\venv\Scripts\activate.bat
```

For Unix

```
source venv/bin/activate
```

## Install Dependencies

```
pip install -r requirements.txt
```

## Setup Environment Variables

```
cp .env.example .env
```

## Run the Application

```
uvicorn main:app --env-file .env --host 0.0.0.0 --port 8000 --reload
```
