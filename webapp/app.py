from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('rapport.html')

if __name__ == '__main__':
    app.run(debug=True)  #Trenger ikke restarte serv ver for å teste endringer