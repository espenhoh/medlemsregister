from flask import Flask, render_template
import sql

app = Flask(__name__)

@app.route('/')
def index():
    klubbregister = sql.klubbregister()
    medlemmer = klubbregister.kjør_pandas('SELECT * FROM Medlem;')
    return render_template('rapport.html', 
                           overskrift = 'Oversikt over alle medlemmer',
                           tabeller=[medlemmer.to_html(classes='table-responsive')],
                           titler=[''])

@app.route('/andre')
def andre_feil():
    klubbregister = sql.klubbregister()
    andre_feil = klubbregister.kjør_pandas('SELECT * FROM v_andre_feil ORDER BY Medlemsnummer;')
    return render_template('rapport.html', 
                           overskrift = 'Andre feil i medlemsregisteret',
                           tabeller=[andre_feil.to_html(classes='table-responsive')],
                           titler=[''])

@app.route('/medlemstype')
def feil_medlemstype():
    klubbregister = sql.klubbregister()
    feil_medlemstype = klubbregister.kjør_pandas('SELECT * FROM v_feil_medlemstype;')
    return render_template('rapport.html', 
                           overskrift = 'Medlemmer registrert med feil medlemstype beregnet fra alder',
                           tabeller=[feil_medlemstype.to_html(classes='table-responsive')],
                           titler=[''])


@app.route('/betalinger')
def feil_innbetaling():
    klubbregister = sql.klubbregister()
    gale_innbetalinger_korrigert_medlemstype = klubbregister.kjør_pandas('SELECT * FROM  v_gale_innbetalinger_korrigert_medlemstype ORDER BY Medlemsnummer;')
    gale_innbetalinger_medlemsnr = klubbregister.kjør_pandas('SELECT * FROM  v_gale_innbetalinger_medlemsnr ORDER BY Medlemsnummer;')
    gale_innbetalinger = klubbregister.kjør_pandas('SELECT * FROM  v_gale_innbetalinger ORDER BY Medlemsnummer;')

    return render_template('rapport.html', 
                           overskrift = 'Oversikt over gale innbetalinger',
                           tabeller=[gale_innbetalinger.to_html(classes='table-responsive'), 
                                     gale_innbetalinger_korrigert_medlemstype.to_html(classes='table-responsive'),
                                     gale_innbetalinger_medlemsnr.to_html(classes='table-responsive'),],
                           titler=['Gale innbetalinger basert på medlemstype registrert i medlem',
                                   'Gale innbetalinger basert på korrekt medlemstype ut i fra alder',
                                   'Betalinger utført av medlemer uten unikt medlemsnummer'])


if __name__ == '__main__':
    app.run(debug=True)  #Trenger ikke restarte serv ver for å teste endringer