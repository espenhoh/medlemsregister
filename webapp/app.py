from flask import Flask, render_template
import sql

app = Flask(__name__)

@app.route('/')
def index():
    
    sqlstr = 'SELECT * FROM v_alle_medlemmer;'
    
    klubbregister = sql.klubbregister()
    medlemmer = klubbregister.kjør_pandas(sqlstr, ['Fødselsdato'])
    
    
    medlemmer['Fødselsdato'] = medlemmer['Fødselsdato'].dt.strftime('%d.%m.%Y')
    return render_template('rapport.html', 
                           overskrift = 'Oversikt over alle medlemmer',
                           tabeller=[medlemmer.to_html(classes='table-hover', index=False)],
                           titler=[''])

@app.route('/andre')
def andre_feil():
    klubbregister = sql.klubbregister()
    andre_feil = klubbregister.kjør_pandas('SELECT * FROM v_andre_feil ORDER BY Medlemsnummer;', None)
    return render_template('rapport.html', 
                           overskrift = 'Andre feil i medlemsregisteret',
                           tabeller=[andre_feil.to_html(classes='table-hover', index=False)],
                           titler=[''])

@app.route('/medlemstype')
def feil_medlemstype():
    klubbregister = sql.klubbregister()
    feil_medlemstype = klubbregister.kjør_pandas('SELECT * FROM v_feil_medlemstype ORDER BY Medlemsnummer;',None)
    return render_template('rapport.html', 
                           overskrift = 'Medlemmer registrert med feil medlemstype beregnet fra alder',
                           tabeller=[feil_medlemstype.to_html(classes='table-hover', index=False)],
                           titler=[''])


@app.route('/betalinger')
def feil_innbetaling():
    klubbregister = sql.klubbregister()
    
    gale_innbetalinger = klubbregister.kjør_pandas('SELECT * FROM  v_gale_innbetalinger ORDER BY Medlemsnummer;',None)
    gale_innbetalinger = gale_innbetalinger.round({'innbetalt': 20, 'Korrekt kontingent': 20})
    
    
    gale_innbetalinger_korrigert_medlemstype = klubbregister.kjør_pandas('SELECT * FROM  v_gale_innbetalinger_korrigert_medlemstype ORDER BY Medlemsnummer;',None)
    
    gale_innbetalinger_medlemsnr = klubbregister.kjør_pandas('SELECT * FROM  v_gale_innbetalinger_medlemsnr ORDER BY Medlemsnummer;',['Innbetalt_dato'])
    gale_innbetalinger_medlemsnr['Innbetalt dato'] = gale_innbetalinger_medlemsnr['Innbetalt dato'].dt.strftime('%d.%m.%Y')
    

    return render_template('rapport.html', 
                           overskrift = 'Oversikt over gale innbetalinger',
                           tabeller=[gale_innbetalinger.to_html(classes='table-hover', index=False), 
                                     gale_innbetalinger_korrigert_medlemstype.to_html(classes='table-hover', index=False),
                                     gale_innbetalinger_medlemsnr.to_html(classes='table-hover', index=False),],
                           titler=['Gale innbetalinger basert på medlemstype registrert i medlem',
                                   'Gale innbetalinger basert på korrekt medlemstype beregnet ut fra alder',
                                   'Betalinger utført av medlemmer uten unikt medlemsnummer'])


if __name__ == '__main__':
    app.run(debug=True)  #Trenger ikke restarte serv ver for å teste endringer