import pytest as pytest

from stattest.test.normality import SWTest
from stattest.tests.normality.AbstractTestCase import AbstractTestCase


@pytest.mark.parametrize(
    ("data", "result"),
    [
        ([16, 18, 16], 0.75),
        ([16, 18, 16, 14], 0.9446643),
        ([16, 18, 16, 14, 15], 0.955627),
        ([38.7, 41.5, 43.8, 44.5, 45.5, 46.0, 47.7, 58.0], 0.872973),
    ],
)
class TestCaseSWTest(AbstractTestCase):

    @pytest.fixture
    def statistic_test(self):
        return SWTest()
