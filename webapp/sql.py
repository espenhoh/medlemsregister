# -*- coding: utf-8 -*-

import mysql.connector
import pandas as pd

class klubbregister(object):
    
    def __init__(self,):
        self.cnxn = mysql.connector.connect(user='rapporter', password='123456', host='127.0.0.1', database='klubb')
        
    def close(self):
        self.cnxn.close()
    
    def kjør_pandas(self, sql, datoer):
        pd.set_option('display.max_colwidth', -1)
        pd.options.display.float_format = 'kr {:,.2f}'.format
        df = pd.read_sql_query(sql, self.cnxn, index_col=None, coerce_float=True, params=None, parse_dates=datoer, chunksize=None)
        # Fjerner '_' fra overskrifter
        df.rename(columns=lambda header: header.replace('_', ' '), inplace=True)
        return df
    
    