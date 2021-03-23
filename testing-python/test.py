import unittest
import util

# python -m unittest test.py

class TestUtil(unittest.TestCase):

    def test_add(self):
        result = util.add(5,6)
        self.assertEqual(result, 5+6)

    def test_divide(self):
        with self.assertRaises(ValueError):
            util.divide(10, 0)



if __name__ == '__main__':
    unittest.main()
