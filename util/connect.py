import psycopg2
from configparser import ConfigParser




class Connector:
    def __init__(self, config_file='config.ini', section='postgresql'):
        self.config = self._config(config_file, section)
        self.conn = self._connect(self.config)

    def _connect(self, params):
        conn = None
        try:
            conn = psycopg2.connect(**params)

            cur = conn.cursor()

            vers = cur.execute('SELECT version()')
            db_version = cur.fetchone()
            print('db version:')
            print(db_version)

            cur.close()
        except (Exception, psycopg2.DatabaseError) as error:
            print(f'Error on connection: {error}')

        finally:
            if conn is not None:
                return conn

    def _config(self, filename, section):
        parser = ConfigParser()

        parser.read(filename)

        db = {}

        if parser.has_section(section):
            params = parser.items(section)
            for param in params:
                db[param[0]] = param[1]
        else:
            raise Exception(f'Sectio {section} not foundin the {filename} file.')

        return db

    def query(self, SQL):
       """
        Wrapper to run SQL statements.
        Mostly to handle exceptions in the future, doesn't do much yet
       """
        with self.conn.cursor() as curs:
            try:
                curs.execute(SQL)
                return True, curs.fetchall()

            except Exception as e
                print(e)
                return False, None

    def test_query(self):
        cur = self.conn.cursor()
        quer = cur.execute('SELECT 1;')
        quer = cur.fetchone()
        return quer[0]

if __name__ == '__main__':
    tster = Connector()
    print(tster)    
