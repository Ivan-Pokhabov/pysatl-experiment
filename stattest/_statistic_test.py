from dataclasses import dataclass
from typing import Callable
from experiment._distribution_type_enum import Distribution
from experiment._hypothesis_enum import Hypothesis


@dataclass
class StatisticTest:
    """
    Class for representing statistic test.
    """
    dist_type: Distribution = None
    hypothesis: Hypothesis = None
    stat_func: Callable = None
    limit_dist: Distribution = None
