import pytest as pytest

from stattest.test.normality import CabanaCabana2Test
from stattest.tests.normality.AbstractTestCase import AbstractTestCase


@pytest.mark.parametrize(
    ("data", "result"),
    [
        ([-0.2115733, -0.8935314, -0.1916746,  0.2805032,  1.3372893, -0.4324158,  2.8578810], 0.2497146),
        ([0.99880346, -0.07557944, 0.25368407, -1.20830967, -0.15914329, 0.16900984,
          0.99395022, -0.28167969, 0.11683112, 0.68954236], 0.1238103),
    ],
)
class TestCaseCabanaCabana2Test(AbstractTestCase):

    @pytest.fixture
    def statistic_test(self):
        return CabanaCabana2Test()
