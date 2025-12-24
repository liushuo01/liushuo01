from flask import Flask, render_template, request, redirect, url_for, session
from datetime import datetime
import sqlite3
import os

app = Flask(__name__)
app.secret_key = 'your_secret_key'  # 生产环境中应该使用更安全的密钥

# 初始化数据库
def init_db():
    conn = sqlite3.connect('app.db')
    cursor = conn.cursor()
    
    # 创建用户表
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL
        )
    ''')
    
    # 创建预约表
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS appointments (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            game TEXT NOT NULL,
            appointment_time TEXT NOT NULL,
            submit_time TEXT NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users (id)
        )
    ''')
    
    conn.commit()
    conn.close()

# 登录页面
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        conn = sqlite3.connect('app.db')
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM users WHERE username = ? AND password = ?', (username, password))
        user = cursor.fetchone()
        conn.close()
        
        if user:
            session['user_id'] = user[0]
            session['username'] = user[1]
            return redirect(url_for('appointment'))
        else:
            return render_template('login.html', error='用户名或密码错误')
    
    return render_template('login.html')

# 注册页面
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        conn = sqlite3.connect('app.db')
        cursor = conn.cursor()
        
        try:
            cursor.execute('INSERT INTO users (username, password) VALUES (?, ?)', (username, password))
            conn.commit()
            conn.close()
            return redirect(url_for('login'))
        except sqlite3.IntegrityError:
            conn.close()
            return render_template('register.html', error='用户名已存在')
    
    return render_template('register.html')

# 预约页面
@app.route('/appointment', methods=['GET', 'POST'])
def appointment():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if request.method == 'POST':
        game = request.form['game']
        appointment_time = request.form['appointment_time']
        submit_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        
        conn = sqlite3.connect('app.db')
        cursor = conn.cursor()
        cursor.execute('''
            INSERT INTO appointments (user_id, game, appointment_time, submit_time)
            VALUES (?, ?, ?, ?)
        ''', (session['user_id'], game, appointment_time, submit_time))
        conn.commit()
        conn.close()
        
        return render_template('appointment.html', success='预约成功！')
    
    return render_template('appointment.html')

# 退出登录
@app.route('/logout')
def logout():
    session.pop('user_id', None)
    session.pop('username', None)
    return redirect(url_for('login'))

if __name__ == '__main__':
    init_db()
    app.run(debug=True)