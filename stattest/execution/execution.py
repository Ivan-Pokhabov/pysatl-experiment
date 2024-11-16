import csv
import os
from os import walk

import stattest.execution.utils as utils
from stattest.execution.cache import CacheResultService
from stattest.test import AbstractTestStatistic
from tqdm import tqdm

from stattest.experiment.test.power_calculation import calculate_powers


def update_result(headers: [str], cache: CacheResultService, alpha: float, rvs_code: str, size: int, result: []):
    if len(result) != len(headers):
        raise RuntimeError('Length of headers and result must be equal')
    for i in range(len(result)):
        keys = [rvs_code, str(alpha), str(size), headers[i]]
        cache.put_with_level(keys, result[i])


def execute_powers(tests: [AbstractTestStatistic], alpha: [float], data_path='data', result_path='result',
                   recalculate=False):
    if not os.path.exists(result_path):
        os.makedirs(result_path)

    headers = [x.code() for x in tests]
    file_path = os.path.join(result_path, 'result.json')
    cache = CacheResultService(filename=file_path, separator=':')
    filenames = next(walk(data_path), (None, None, []))[2]  # [] if no file
    t = tqdm(total=len(tests) * len(alpha) * len(filenames))

    for filename in filenames:
        rvs_code, size = utils.parse_rvs_file_name(filename)
        file_path = os.path.join(data_path, filename)
        with open(file_path, newline='') as f:
            reader = csv.reader(f, delimiter=utils.CSV_SEPARATOR, quoting=csv.QUOTE_NONNUMERIC)
            data = list(reader)
            for level in alpha:
                powers = calculate_powers(tests, data, t, level)
                print('POWER CALCULATED', filename, str(level))
                update_result(headers, cache, level, rvs_code, size, powers)
            cache.flush()

#if __name__ == '__main__':
#    tests = [ADTest()]
#    alpha = [0.05]
#    execute_powers(tests, alpha)
