import sys
import unittest
from os import getcwd, path




#########
# Testing /carapp/util/
#########

class TestUtil(unittest.TestCase):
    def __init__(self):
        super().__init__()
        self.test_connect()

    def test_connect(self):
        """
        Tests if the connection to the database goes well.
        Queries test table with a 1 in it.
        If returns, connection is succesful.
        """
        # Setup
        sys.path.insert(0, '/home/basket/carapp/util')
        import connect

        connector = connect.Connector(config_file='/home/basket/carapp/util/config.ini')

        # Target
        connect_test = int(1)

        # Result
        connect_result = connector.test_query()

        # Comparison
        self.assertEqual(connect_result, connect_test)

if __name__ == '__main__':
    util_test = TestUtil()
