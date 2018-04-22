from flask import Flask, render_template
import sql

app = Flask(__name__)

@app.route('/')
def index():
    klubbregister = sql.klubbregister()
    medlemmer = klubbregister.kjør_pandas('SELECT * FROM Medlem;')

    return render_template('rapport.html', tabell=medlemmer.to_html(classes='table-responsive'))

if __name__ == '__main__':
    app.run(debug=True)  #Trenger ikke restarte serv ver for å teste endringer