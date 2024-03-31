import pytest as pytest

from stattest.test.normality import RyanJoinerTest
from stattest.tests.AbstractTestCase import AbstractTestCase


@pytest.mark.parametrize(
    ("data", "result"),
    [
        ([148, 154, 158, 160, 161, 162, 166, 170, 170, 182, 195], 0.9565242082866772),
        ([6, 1, -4, 8, -2, 5, 0], 0.9844829186140105),
    ],
)
class TestCaseRJTest(AbstractTestCase):

    @pytest.fixture
    def statistic_test(self):
        return RyanJoinerTest()
