import pytest as pytest

from stattest.test.normality import DoornikHansenTest
from stattest.tests.AbstractTestCase import AbstractTestCase


@pytest.mark.parametrize(
    ("data", "result"),
    [
        ([-1.09468228, -0.31322754, -0.78294147, -0.58466218, 0.09357476, 0.35397261,
          -2.77320261, 0.29275119, -0.66726297, 2.17449000], 7.307497),
        ([-0.67054898, -0.96828029, -0.84417791, 0.06829821, 1.52624840, 1.72143189,
          1.50767670, -0.08592902, -0.46234996, 0.29561229, 0.32708351], 2.145117),
    ],
)
class TestCaseDoornikHasenTest(AbstractTestCase):

    @pytest.fixture
    def statistic_test(self):
        return DoornikHansenTest()
