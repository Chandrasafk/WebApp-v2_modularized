#!/bin/bash
# 1. Update system packages and install python/mariadb
dnf update -y
dnf install -y python3 python3-pip mariadb105

# 2. Create application directory
mkdir -p /var/www/taskmanager

# 3. Set up a Python Virtual Environment (Required by Amazon Linux 2023)
python3 -m venv /var/www/taskmanager/venv
/var/www/taskmanager/venv/bin/pip install --upgrade pip
/var/www/taskmanager/venv/bin/pip install flask gunicorn pymysql

# 4. Create the Flask Application file
cat > /var/www/taskmanager/app.py << 'APPEOF'
from flask import Flask, request, jsonify
import pymysql
import os

app = Flask(__name__)

def get_db():
    return pymysql.connect(
        host=os.environ.get('DB_HOST'),
        user=os.environ.get('DB_USER'),
        password=os.environ.get('DB_PASSWORD'),
        database='taskmanager',
        cursorclass=pymysql.cursors.DictCursor
    )

@app.route('/')
def index():
    return '<html><body><h2>Task Manager</h2><form method="POST" action="/tasks"><input type="text" name="title" placeholder="Enter task" required><button type="submit">Add Task</button></form><br><a href="/tasks">View all tasks</a></body></html>'

@app.route('/tasks', methods=['GET'])
def get_tasks():
    conn = get_db()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM tasks")
            tasks = cursor.fetchall()
        return jsonify(tasks)
    finally:
        conn.close()

@app.route('/tasks', methods=['POST'])
def add_task():
    title = request.form.get('title')
    conn = get_db()
    try:
        with conn.cursor() as cursor:
            cursor.execute("INSERT INTO tasks (title) VALUES (%s)", (title,))
        conn.commit()
        return '<html><body><p>Task added.</p><a href="/">Go back</a></body></html>'
    finally:
        conn.close()

if __name__ == '__main__':
    app.run()
APPEOF

# 5. Create the systemd service unit to run Gunicorn on port 8000
cat > /etc/systemd/system/taskmanager.service << SVCEOF
[Unit]
Description=Task Manager Flask App
After=network.target

[Service]
User=root
WorkingDirectory=/var/www/taskmanager
Environment="DB_HOST=${db_host}"
Environment="DB_USER=admin"
Environment="DB_PASSWORD=${db_password}"
ExecStart=/var/www/taskmanager/venv/bin/gunicorn --bind 0.0.0.0:8000 app:app
Restart=always

[Install]
WantedBy=multi-user.target
SVCEOF

# 6. Reload systemd and start the application
systemctl daemon-reload
systemctl start taskmanager
systemctl enable taskmanager

# 7. Initialize the RDS Database schema
mysql -h ${db_host} -u admin -p${db_password} -e "
CREATE DATABASE IF NOT EXISTS taskmanager;
USE taskmanager;
CREATE TABLE IF NOT EXISTS tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
"