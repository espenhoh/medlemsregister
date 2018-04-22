# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
#import pyodbc

import mysql.connector
import datetime
#import numpy as np
from pandas import read_sql_query

class klubbregister(object):
    
    def __init__(self,):
        #self.connString = 'DSN=' + database + ';Database='+ catalog + ';UID=root;PWD=root'
        #self.cnxn = pyodbc.connect(self.connString)
        
        self.cnxn = mysql.connector.connect(user='root', password='root', host='127.0.0.1', database='klubb') # må lage bruker uten rottilgang
        
    def close(self):
        self.cnxn.close()
    
    def kjør_pandas(self, sql):
        return self.kjør_pandas_raw(sql, None)

    def kjør_pandas_raw(self, sql, dates):
        print("Connecting to database with query: " + sql)
        return read_sql_query(sql, self.cnxn, index_col=None, coerce_float=True, params=None, parse_dates=dates, chunksize=None) 
    
    
if __name__ == "__main__":
    klubb = klubb() 
    sql = 'SELECT * FROM Medlem;'
    medlemmer = klubb.kjør_pandas(sql)
    
    print(medlemmer)
    
    